# Mimonixos

Collection of my NixOS configs

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

### 1.5 Aliases

Once the system is rebuilt you can use aliases for rebuliding, testing, editing, updating and deploying this config:

List them with:
```bash
alias | grep mim
```


## 2. TODO: Other hosts
- nixos-anywhere
- disko
