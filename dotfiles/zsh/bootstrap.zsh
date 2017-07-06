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
ZSH_THEME_PATH=$WORKSTATION/dotfiles/zsh/plugins/mtxr-themes
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE
WORKSTATION_AUTOUPDATE=true
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
