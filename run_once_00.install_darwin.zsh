#!/usr/bin/zsh

{{- if (eq .chezmoi.os "darwin") -}}

set -e # -e: exit on error

export GOPATH=$HOME/projects/go

brew install -f zsh git curl golang pv bat ruby aria2 hub fd ruby-devel

{{ end }}