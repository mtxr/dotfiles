if type cursor &> /dev/null; then
  export EDITOR=cursor
  if ! type code &> /dev/null; then
    alias code=cursor
  fi
elif type code-insiders &> /dev/null; then
  export EDITOR=code-insiders
  if ! type code &> /dev/null; then
    alias code=code-insiders
  fi
else
  if type code &> /dev/null; then
    export EDITOR=code
  fi
fi
export VISUAL=$EDITOR
export REACT_EDITOR=$VISUAL

zstyle ':completion:*' menu select
# zstyle ':completion:*' menu select=0 yes search
zstyle ':completion:*' group-name ''
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
zstyle ':completion:*' format '%F{blue}%B -- %d -- %b%f'
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

# Initialize editing command line
autoload -U edit-command-line && zle -N edit-command-line

zmodload zsh/complist

# Time to wait for additional characters in a sequence
KEYTIMEOUT=1 # corresponds to 10ms


# Fixes [home|end] keys
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line

# Fixes [home|end] keys MACOS
bindkey "^[[1;10D" beginning-of-line
bindkey "^[[1;10C" end-of-line

# Fixes [home|end] keys VSCODE
bindkey "^[[1;4D" beginning-of-line
bindkey "^[[1;4C" end-of-line

# Fixes Ctrl+[B|E] keys
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# Fixes Alt+[left|right] keys
bindkey "^[[1;3D" beginning-of-line
bindkey "^[[1;3C" end-of-line

# Fixes Alt+[left|right] keys MACOS
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word

# Fixes Alt+[left|right] keys VSCODE
bindkey "^[b" backward-word
bindkey "^[f" forward-word

# delete key
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "^[[3;5~" delete-word
bindkey '^[' backward-delete-word # ctrl [
bindkey '^]' delete-word # ctrl ]

# backspace key
bindkey "^H" backward-delete-word

# zsh undo/redo
bindkey '^[z' undo
bindkey '^[Z' redo

# Shift tab for menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

export FZF_DEFAULT_OPTS="--no-256 --ansi --cycle --border --height=15"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"