export TERM="xterm-256color"
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less
export LESS='-F -g -i -M -R -S -w -X -z-4'
export WORDCHARS=''
export PROJECTS=$HOME/projects
export WORKSTATION=$HOME/.workstation
export PATH="$WORKSTATION/bin:$HOME/bin:/usr/local/sbin:$PATH"
export ZSH_THEME_PATH=$WORKSTATION/dotfiles/zsh/plugins/mtxr-themes
export GIT_CLEAR_BRANCH_EXCLUDE="release|develop|master"
export fpath=( $HOME/.autoload-zsh $fpath )
export VSCODE_FILE=$HOME/.vscode-cli

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

ZSH_THEME="geometry" # options = (default, powerlevel, geometry)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE
WORKSTATION_AUTOUPDATE=true

setopt autocd # Set automatic cd (typing directory name with no 'cd')
setopt interactivecomments # Enable interactive comments (# on the command line)
# Nicer history
setopt appendhistory
setopt incappendhistory
setopt extendedhistory
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

# Initialize completion
autoload -Uz compinit
autoload -Uz bashcompinit

if [ -e ~/.zcompdump ] && [ $(date +'%Y%j') != $(stat -f '%Sm' -t '%Y%j' ~/.zcompdump) ]; then
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

# Fixes Alt+[left|right] keys
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word

# Fixes [home|end] keys
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

# Fixes Ctrl+[left|right] keys
bindkey "^[[1;5D" beginning-of-line
bindkey "^[[1;5C" end-of-line

# Fixes Ctrl+[B|E] keys
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

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
