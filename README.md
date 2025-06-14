# Workstation Setup

This repository contains my personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Table of Contents
- [Features](#features)
- [Quick Start](#quick-start)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Manual Setup](#manual-setup)
- [Configuration](#configuration)
- [Local Customizations](#local-customizations)
- [Updating](#updating)
- [Uninstalling](#uninstalling)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Features

- **Cross-platform** support (macOS/Linux)
- **Modular** configuration
- **Secure** handling of sensitive data
- **Automatic** dependency installation
- **Easy** updates and maintenance

## Quick Start

### Prerequisites

- [Git](https://git-scm.com/)
- [cURL](https://curl.se/)
- [Homebrew](https://brew.sh/) (macOS/Linux)
- [Zsh](https://www.zsh.org/) (will be installed automatically if not present)

### Installation

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin init --apply mtxr/dotfiles
```

This will:
1. Install chezmoi if not already installed
2. Initialize the dotfiles repository
3. Apply the configuration to your system

#### Alternative (if you have chezmoi already installed):

```bash
chezmoi init --apply mtxr/dotfiles
```

#### Updating:

```bash
chezmoi update
```

#### Shell Changes

The installer will automatically:
1. Install Zsh if not already present
2. Set Zsh as your default shell
3. Apply Zsh configuration from the dotfiles

**Note:** The shell change will take effect in new terminal sessions. After installation, please open a new terminal to start using Zsh.

### Manual Setup

1. Clone this repository:
   ```bash
   chezmoi init --apply mtxr/dotfiles
   ```

2. Follow the interactive prompts to configure your system

## Configuration

Edit `~/.local/share/chezmoi/chezmoi.toml.tmpl` to modify default settings. The configuration includes:

- User information (name, email)
- SSH key configuration
- Development tools to enable/disable
- Node.js options

## Local Customizations

You can make machine-specific customizations in these files (they won't be tracked by git):

- `~/.gitconfig_local` - Local Git configuration
- `~/.zshrc_local` - Local Zsh configuration
- `~/.localrc` - Local shell configuration (sourced by .zshrc)

## Updating

To update your dotfiles:

```bash
chezmoi update
```

Or manually:

```bash
cd $(chezmoi source-path)
git pull
chezmoi apply
```

## Uninstalling

To remove all dotfiles managed by chezmoi:

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/mtxr/dotfiles/main/uninstall)"
```

Use `--dry-run` to see what would be removed:

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/mtxr/dotfiles/main/uninstall)" -- --dry-run
```

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x ~/.local/bin/chezmoi
   ```

2. **Command Not Found**
   Make sure `~/.local/bin` is in your PATH:
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Chezmoi Not Found After Installation**
   ```bash
   export PATH="$HOME/.local/bin:$PATH"
   ```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a pull request

## Features

- **Cross-platform** support (macOS, Ubuntu, Alpine Linux, and more)
- **Zsh** with plugins (with automatic fallback to Bash on minimal systems)
- **Git** configuration with sensible defaults
- **Homebrew** packages (macOS/Linux)
- Custom scripts and utilities
- Development tools and language support
- **POSIX-compliant** installation and uninstallation scripts
- Automatic dependency management
- Dry-run mode for safe testing
- Color-coded output for better readability
- 1Password integration

## License

MIT
