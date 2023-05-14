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

if ! type volta &> /dev/null ; then
  echo 'Will install volta.sh, the node version manager...'
  eval $WEB_INSTALLER https://get.volta.sh | bash || (echo "##### Failed to install 'N'." && exit 1)
  if [ -d "$HOME/.volta" ]; then
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
  fi
fi
