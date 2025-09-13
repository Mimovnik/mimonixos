# Mimonixos

Collection of my NixOS configs

## Quick Start

For detailed installation instructions, see [INSTALLATION.md](./INSTALLATION.md).

## Templates

Use development shell templates:
```bash
nix flake init -t github:Mimovnik/mimonixos#<template>
```

To discover available templates:
```bash
# Show the flakes outputs
nix flake show github:Mimovnik/mimonixos

# Or get template names directly
nix eval github:Mimovnik/mimonixos#templates --apply builtins.attrNames
```

## Development

### Pre-commit Hooks

This repository uses pre-commit hooks to maintain code quality. To set up the development environment:

```bash
# Enter the development shell
nix develop

# Install pre-commit hooks
pre-commit install
```

The following checks are configured:
- **Conventional Commits**: Enforces commit message format
- **Alejandra**: Nix code formatting
- **File checks**: Trailing whitespace, end-of-file, large files, etc.
- **Data formats**: JSON, YAML, TOML validation and formatting
