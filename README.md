# Workstation Setup

This repository contains my personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

### Prerequisites
- Install [Homebrew](https://brew.sh/) (macOS/Linux)
- Install [chezmoi](https://www.chezmoi.io/install/)

### Installation

#### One-liner:
```bash
sh -c "$(curl -fsLS git.io/.mtxr)"
```

Or with wget:
```bash
sh -c "$(wget -qO- git.io/.mtxr)"
```

### Manual Setup

1. Clone this repo:
   ```bash
   chezmoi init --apply mtxr/dotfiles
   ```

2. Follow the prompts to configure your system

## Configuration

Edit `~/.local/share/chezmoi/chezmoi.toml.tmpl` to modify default settings.

## Local Customizations

You can make machine-specific customizations in these files:

- Git: `~/.gitconfig_local`
- Zsh: `~/.zshrc_local`
- Shell: `~/.localrc` (sourced by .zshrc)

## Updating

To update your dotfiles:
```bash
chezmoi update
```

## Features

- Zsh with plugins
- Git configuration with handy aliases
- SSH key management
- Cross-platform support (macOS/Linux)
- 1Password integration

## License

MIT
