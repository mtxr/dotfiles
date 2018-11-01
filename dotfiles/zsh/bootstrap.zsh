if [ ! -f "$VSCODE_FILE" ];then
  if type code &> /dev/null && type code-insiders &> /dev/null; then
    echo -n "You have VSCode and VSCode Insiders installed.\nWould you like do use (V)SCode or VSCode (I)nsiders? (V/I): " && read -k
    if [[ $REPLY =~ ^[Ii]$ ]];then
      echo "code-insiders" > $VSCODE_FILE
    else
      echo "code-insiders" > $VSCODE_FILE
    fi
  elif type code &> /dev/null; then
    echo "code" > $VSCODE_FILE
  elif type code-insiders &> /dev/null; then
    echo "code-insiders" > $VSCODE_FILE
  else
    echo "" > $VSCODE_FILE
  fi
fi
export VSCODE_CLI=$(cat $VSCODE_FILE)

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=$(($HISTSIZE * 1.5))
WORKSTATION_AUTOUPDATE=true

setopt APPEND_HISTORY
setopt AUTO_CD
setopt AUTO_LIST
setopt CORRECT_ALL
setopt EXTENDED_GLOB
setopt EXTENDED_HISTORY
setopt GLOB_DOTS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt INTERACTIVE_COMMENTS
setopt LIST_TYPES
setopt LONG_LIST_JOBS
setopt MENU_COMPLETE
setopt NO_BEEP
setopt NO_HUP
setopt NOTIFY
setopt NULL_GLOB
setopt PROMPT_SUBST
setopt SHARE_HISTORY

# Initialize completion
autoload -Uz compinit
autoload -Uz bashcompinit

if [ -e ~/.zcompdump ] && [ $(date +'%Y%j') != $(date +'%Y%j' -r ~/.zcompdump) ]; then
  compinit
  bashcompinit
else
  compinit -C
  bashcompinit -C
fi

zstyle ':completion:*' menu select=0 yes search
zstyle ':completion:*:*:*:*:*' menu select=0 yes search
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '%F{blue}%B -- %d -- %b%f'
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

# Initialize editing command line
autoload -U edit-command-line && zle -N edit-command-line


# Time to wait for additional characters in a sequence
KEYTIMEOUT=1 # corresponds to 10ms

# Fixes Ctrl+[left|right] keys
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Fixes [home|end] keys
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

# Fixes Alt+[left|right] keys
bindkey "^[[1;3D" beginning-of-line
bindkey "^[[1;3C" end-of-line

# Fixes Ctrl+[B|E] keys
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# delete key
bindkey "^[[3~" delete-char
bindkey "^[[3;5~" delete-word

# backspace key
bindkey "^H" backward-delete-word

# Shift tab for menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete


# Base16 Google Dark
# Author: Seth Wright (http://sethawright.com)

_gen_fzf_default_opts() {

local color00='#1d1f21'
local color01='#282a2e'
local color02='#373b41'
local color03='#969896'
local color04='#b4b7b4'
local color05='#c5c8c6'
local color06='#e0e0e0'
local color07='#ffffff'
local color08='#CC342B'
local color09='#F96A38'
local color0A='#FBA922'
local color0B='#198844'
local color0C='#3971ED'
local color0D='#3971ED'
local color0E='#A36AC7'
local color0F='#3971ED'

export FZF_DEFAULT_OPTS="
  $@
  --bind=shift-tab:up,tab:down --cycle --reverse --border
  --color=bg+:$color01,spinner:$color0C,hl:$color0D
  --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
  --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
"
}

_gen_fzf_default_opts $FZF_DEFAULT_OPTS
