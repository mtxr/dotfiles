#!/usr/bin/zsh

{{- if (eq .chezmoi.os "linux") -}}

set -e # -e: exit on error

export GOPATH=$HOME/projects/go

# common package names for all linux
COMMON_PACKAGES="zsh git curl golang pv bat ruby aria2 hub fd-find"

if [ "$(command -v dnf)" ]; then
  sudo dnf -y install $COMMON_PACKAGES ruby-devel
elif [ "$(command -v apt)" ]; then
  sudo apt install -y $COMMON_PACKAGES ruby-dev
elif [ "$(command -v apt-get)" ]; then
  sudo apt-get install -y $COMMON_PACKAGES ruby-dev
else
  echo "Couldn't identify OS type. EXITING." >&2
  exit 1
fi

{{ end }}