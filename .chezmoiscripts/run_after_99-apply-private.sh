#!/bin/bash
private="$HOME/.local/share/chezmoi-private"
[[ -d "$private" ]] || exit 0
chezmoi apply --source "$private" --persistent-state "$HOME/.config/chezmoi/chezmoistate-private.boltdb"
