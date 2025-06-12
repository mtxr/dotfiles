#!/usr/bin/env zsh

# all systems
set -e

# Install Python if not present
if ! command -v python3 >/dev/null 2>&1; then
  echo 'Installing Python...'
  if command -v apk >/dev/null 2>&1; then
    # Alpine Linux
    sudo apk add --no-cache python3 py3-pip
  elif command -v apt-get >/dev/null 2>&1; then
    # Ubuntu/Debian
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
  elif command -v brew >/dev/null 2>&1; then
    # macOS (Homebrew)
    brew install python
  else
    echo "Could not determine package manager to install Python" >&2
    exit 1
  fi
fi

if [ "$(command -v curl)" ]; then
  export WEB_INSTALLER="curl -L"
elif [ "$(command -v wget)" ]; then
  export WEB_INSTALLER="wget -qO-"
else
  echo "To install we need curl or wget to be installed to proceed." >&2
  exit 1
fi

if ! type volta &> /dev/null ; then
  echo 'Will install volta.sh, the node version manager...'
  eval $WEB_INSTALLER https://get.volta.sh | bash || (echo "##### Failed to install 'N'." && exit 1)
  if [ -d "$HOME/.volta" ]; then
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
  fi
fi

if ! type bun &> /dev/null ; then
  echo 'Will install bun.sh, the JavaScript runtime & toolkit...'
  eval $WEB_INSTALLER https://bun.sh/install | bash || (echo "##### Failed to install 'bun'." && exit 1)
  if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Set up Homebrew environment based on OS and architecture
  if [ "$OS" = "darwin" ]; then
    # macOS (Intel or Apple Silicon)
    if [ -f /opt/homebrew/bin/brew ]; then
      # Apple Silicon
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
      # Intel
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  else
    # Linux
    if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
      # System-wide installation
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -f "$HOME/.linuxbrew/bin/brew" ]; then
      # User installation
      eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    fi

    # Add Homebrew to PATH if not already there
    if ! echo "$PATH" | grep -q "\.linuxbrew"; then
      echo 'eval "$('"$HOME"'/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.profile"
      eval "$("$HOME"/.linuxbrew/bin/brew shellenv)"
    fi
  fi
fi

