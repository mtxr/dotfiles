export TERM="xterm-256color"
export EDITOR=vi
export VISUAL=$EDITOR
export PAGER=less
export LESS='-F -g -i -M -R -S -w -X -z-4'
export WORDCHARS=''
export PROJECTS=$HOME/projects
export GOPATH=$PROJECTS/go
export WORKSTATION=$HOME/.workstation
export N_PREFIX=${N_PREFIX:-"$HOME/.n"}
export PATH="$WORKSTATION/bin:$HOME/.yarn/bin:$N_PREFIX/bin:$HOME/.local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$HOME/bin:/snap/bin:/usr/local/sbin:/sbin:$PATH"
export GIT_CLEAR_BRANCH_EXCLUDE="release|develop|master|development|staging"
export fpath=( $HOME/.autoload-zsh $fpath )
export VSCODE_FILE=$HOME/.vscode-cli
export GPG_TTY=$(tty)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig/:/usr/share/pkgconfig:/usr/lib/pkgconfig:$PKG_CONFIG_PATH"

eval `gnome-keyring-daemon --start`