if type code-insiders &> /dev/null; then
  if ! type code &> /dev/null; then
    alias code=code-insiders
  fi
fi

if type code &> /dev/null; then
  export EDITOR=code
  export VISUAL=$EDITOR
  export REACT_EDITOR=$VISUAL
fi

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

# Fixes Ctrl+[left|right] keys
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Fixes [home|end] keys
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line

# Fixes Alt+[left|right] keys
bindkey "^[[1;3D" beginning-of-line
bindkey "^[[1;3C" end-of-line

# Fixes Ctrl+[B|E] keys
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

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

