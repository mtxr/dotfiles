export TERM="xterm-256color"
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less
export LESS='-F -g -i -M -R -S -w -X -z-4'
export WORDCHARS=''
export PROJECTS=$HOME/projects
export N_PREFIX="$HOME/.n"
export WORKSTATION=$HOME/.workstation
export PATH="$WORKSTATION/bin:$N_PREFIX/bin:$HOME/bin:$HOME/.cargo/bin:/usr/local/sbin:$PATH"
export ZPLUG_HOME=$HOME/.zplug
export ZSH_THEME_PATH=$WORKSTATION/dotfiles/zsh/plugins/mtxr-themes

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
autoload -U compinit
autoload -U bashcompinit

if [ $(date +'%Y%j') != $(stat -f '%Sm' -t '%Y%j' ~/.zcompdump) ]; then
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
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^R' history-incremental-search-backward
