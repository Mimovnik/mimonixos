# Installation

## 1. Host with NixOS

### 1.1 Enter nix shell with git
```bash
nix --extra-experimental-features "nix-command flakes" shell nixpkgs#git
```

### 1.2 Clone this repo

```bash
git clone https://github.com/Mimovnik/mimonixos ~/.mimonixos
```

### 1.3 Link this config to /etc/nixos

```bash
# Backup default config
sudo mv /etc/nixos /etc/nixos.bak

# Link
sudo ln -s ~/.mimonixos /etc/nixos
```

### 1.4 Rebuild for "myhost"

```bash
sudo nixos-rebuild switch --flake ~/.mimonixos#myhost
```

### 1.5 Setup Home Manager (Standalone)

Since this configuration uses standalone Home Manager, you'll need to set it up separately:

#### 1.5.1 Install Home Manager
```bash
nix run home-manager/release-25.05 -- init --switch
```

#### 1.5.2 Apply your Home Manager configuration
```bash
home-manager switch --flake ~/.mimonixos#${USER}@myhost
```

Replace `myhost` with your actual hostname and `${USER}` with your username.

#### 1.5.3 Available Home Manager configurations
To see all available Home Manager configurations:
```bash
nix flake show ~/.mimonixos | grep homeConfigurations
```

### 1.6 Rebuilding

For future updates, you'll need to rebuild both NixOS and Home Manager:

```bash
# Rebuild NixOS system
sudo nixos-rebuild switch --flake ~/.mimonixos#myhost

# Rebuild Home Manager
home-manager switch --flake ~/.mimonixos#${USER}@myhost
```

> [!TIP]
> This configuration includes `nh` (Nix Helper) which provides a more user-friendly interface:
> ```bash
> # NixOS system rebuild
> nh os switch
>
> # Home Manager rebuild
> nh home switch
> ```
> `nh` automatically detects your hostname and provides better output formatting, progress indicators, and error handling.

## 2. Other hosts

### 2.1 Manual install with live iso

Download iso image from [here](https://nixos.org/download/#nix-more).


Determine usb drive name /dev/sd*X* with:
```bash
sudo blkid
```


Flash an usb drive:
```bash
cp /path/to/iso/file /dev/sdX
sync
```

> [!NOTE]
> This may take a while and no output is printed during the copying.

Before rebooting you may need to reorder the boot records so the live iso is the first record to boot.


You can do it in your BIOS/UEFI or:
> On UEFI you can use 'efibootmgr' utility:
>
> See the current boot order:
> ```bash
> efibootmgr
> ```
> or on nix:
> ```bash
> nix run nixpkgs#efibootmgr
> ```
> Look for the name of your usb drive
>
> Change the order so nixos
> ```bash
> sudo efibootmgr -o 0007,0002,0003
> ```


Boot into the live iso


Proceed with the installation


### 2.2 Remote install

You can install nixos remotely via ssh using [nixos-anywhere](https://github.com/nix-community/nixos-anywhere)
I have followed [this](https://github.com/nix-community/nixos-anywhere/blob/main/docs/quickstart.md) guide.

#### Prerequisites
- Target host
- Source host with nix
- Network connectivity between the two

#### Steps I've taken

Edit target host config on source machine


1. Add authorized keys to new host config:
Somewhere in the nixos module add
```nix
users.users.${username}.openssh.authorizedKeys.keys = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdW1UbkbF0p1yTBh2CKv//RsDvot07/t7AtdNGeAsx/ mimo@glados"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPb0nrIl2mNjcXMmYWIMalZUGb9Kv/1htsLtqA8hYC/F mimovnik@walle"
];
```
or import `modules/system/common/authorized-keys.nix`


> [!NOTE]
> It is already imported in `modules/system/base/default.nix`


2. Configure storage using [disko](https://github.com/nix-community/disko)
Create `disko-config.nix`


Import it in host's system config


Specify the main device:


```nix
disko.devices.disk.main.device = "/dev/sda";
```

3. Start target host
Boot into some linux with openssh


If you don't have os enter some live iso


4. Test ssh connectivity for root on target host
nixos-anywhere requires either ssh to root or passwordless sudo


On nixos iso you can change the root password with `sudo passwd` because sudo doesn't need authentication


Test with:
```bash
TARGET=192.168.0.5
ssh root@$TARGET
```


5. Run nixos-anywhere
```bash
CONFIG="samurai-tv"
TARGET=192.168.0.5
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ~/.mimonixos/hosts/$CONFIG/hardware-configuration.nix --flake ~/.mimonixos#$CONFIG --target-host root@$TARGET
```

> [!NOTE]
> git add any new files regarding the new host configuration
> nix won't see the files unless they are staged

6. Setup Home Manager on the new host
After nixos-anywhere completes, SSH into the new host and set up Home Manager:

```bash
# SSH to the new host
ssh ${USER}@$TARGET

# Install Home Manager
nix run home-manager/release-25.05 -- init --switch

# Apply your Home Manager configuration
home-manager switch --flake ~/.mimonixos#${USER}@$CONFIG
```

Example of such configuration is in `hosts/samurai-tv`
> [!NOTE]
> I didn't have hardware-configuration.nix before running nixos-anywhere
> Although I imported it in system.nix

## Quick Reference

### Rebuild Commands

For daily use, here are the commands you'll need:

**Using `nh` (recommended):**
```bash
# NixOS system rebuild
nh os switch

# Home Manager rebuild
nh home switch

# Both together
nh os switch && nh home switch
```

**Traditional commands:**
```bash
# NixOS system rebuild
sudo nixos-rebuild switch --flake ~/.mimonixos#$(hostname)

# Home Manager rebuild
home-manager switch --flake ~/.mimonixos#${USER}@$(hostname)

# Both together (useful for updates)
sudo nixos-rebuild switch --flake ~/.mimonixos#$(hostname) && home-manager switch --flake ~/.mimonixos#${USER}@$(hostname)
```

### Available Configurations

List all available configurations:
```bash
# NixOS configurations
nix eval ~/.mimonixos#nixosConfigurations --apply builtins.attrNames

# Home Manager configurations
nix eval ~/.mimonixos#homeConfigurations --apply builtins.attrNames
```
