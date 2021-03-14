#!/usr/bin/zsh

# all systems

if [[ ! -d "$N_PREFIX" ]]; then
  echo 'Will install N, the node version manager...' && \
  eval $WEB_INSTALLER https://git.io/n-install | N_PREFIX=$N_PREFIX bash -s -- -y -n || echo "##### Failed to install 'N'."
fi

echo "Installing GO apps"
go get -u github.com/augustoroman/highlight
go get -u github.com/arl/gitmux

echo Installing brew apps
brew install ripgrep fzf
