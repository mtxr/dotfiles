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

setopt prompt_subst # Prompt Substitution
setopt autocd # Set automatic cd (typing directory name with no 'cd')
setopt interactivecomments # Enable interactive comments (# on the command line)
# Nicer history
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt hist_ignore_all_dups
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

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

zstyle ':completion:*' menu select=20
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

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

# fix null glob
setopt null_glob

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
