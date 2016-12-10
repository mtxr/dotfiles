export TERM="xterm-256color"
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less
export LESS='-F -g -i -M -R -S -w -X -z-4'
export PROJECTS=$HOME/projects
export PATH=~/.dotfiles/bin:$HOME/bin:/usr/local/sbin:$PATH
export LWD=$(cat ~/.lwd 2> /dev/null || echo $HOME)
export WORDCHARS=''
HISTSIZE=1048576
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE

cd $LWD