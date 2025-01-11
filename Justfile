# Rebuild and switch
switch:
  sudo nixos-rebuild switch

# Rebuild but don't switch
test:
  sudo nixos-rebuild test --show-trace

# Update whole system
up:
  sudo nix flake update

# Update specific input
upp INPUT:
  sudo nix flake lock --update-input {{INPUT}}

# Show generations history
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Search tree: '/<package-name>' to search for a package and 'w' to show dependencies
tree:
  nix-store --gc --print-roots | rg -v '/proc/' | rg -Po '(?<= -> ).*' | xargs -o nix-tree

# Start repl
repl:
  nix repl -f flake:nixpkgs

# Remove all generations older than 7 days
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# Garbage collect all unused nix store entries
gc:
  sudo nix-collect-garbage --delete-old
