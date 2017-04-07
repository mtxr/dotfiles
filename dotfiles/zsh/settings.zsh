POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vcs)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="╰> "
POWERLEVEL9K_MODE='awesome-patched'
ZSH_THEME="powerlevel" # options = (default, powerlevel)
PATH="$PATH:$HOME/.cargo/bin"

# Initialize completion
autoload -Uz compinit
if [ $(date +'%Y%j') != $(stat -f '%Sm' -t '%Y%j' ~/.zcompdump) ]; then
    compinit
else
    compinit -C
fi

zstyle ':completion:*' menu select=20
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

# Initialize editing command line
autoload -U edit-command-line && zle -N edit-command-line

# Set automatic cd (typing directory name with no 'cd')
setopt autocd

# Enable interactive comments (# on the command line)
setopt interactivecomments

# Nicer history
setopt appendhistory
setopt incappendhistory
setopt extendedhistory

# Time to wait for additional characters in a sequence
KEYTIMEOUT=1 # corresponds to 10ms

# Fixes Ctrl+[left|right] keys
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^R' history-incremental-search-backward
