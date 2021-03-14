#!/usr/bin/env zsh

# all systems
set -e

if [ "$(command -v curl)" ]; then
  export WEB_INSTALLER="curl -L"
elif [ "$(command -v wget)" ]; then
  export WEB_INSTALLER="wget -qO-"
else
  echo "To install we need curl or wget to be installed to proceed." >&2
  exit 1
fi

export N_PREFIX=${N_PREFIX:-"$HOME/.n"}

if [[ ! -d "$N_PREFIX" ]]; then
  echo 'Will install N, the node version manager...' && \
  eval $WEB_INSTALLER https://git.io/n-install | bash -s -- -y -n || (echo "##### Failed to install 'N'." && exit 1)
  zsh -c "npm install -g yarn"
fi

TO_INSTALL=""
type diff-so-fancy &> /dev/null || TO_INSTALL="$TO_INSTALL diff-so-fancy"

if [ "$TO_INSTALL" != "" ]; then
  echo "Installing '$TO_INSTALL'..."
  zsh -c "npm install -g $TO_INSTALL" > /dev/null || (echo "##### Failed to install '$TO_INSTALL'" && exit 1)
fi

echo "Installing GO apps"
go get -u github.com/augustoroman/highlight
go get -u github.com/arl/gitmux

echo Installing brew apps
brew install ripgrep fzf
