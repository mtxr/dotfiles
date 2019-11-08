export TERM=${TERM:-screen-256color}
export EDITOR=vi
export VISUAL=$EDITOR
export PAGER=less
export LESS='-F -g -i -M -R -S -w -X -z-4'
export WORDCHARS=''
export PROJECTS=$HOME/projects
export GOPATH=$PROJECTS/go
export DOTFILES=$HOME/.dotfiles
export N_PREFIX=${N_PREFIX:-"$HOME/.n"}
export PATH="$DOTFILES/bin:$HOME/.yarn/bin:$N_PREFIX/bin:$HOME/.local/bin:$GOPATH/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$HOME/bin:/snap/bin:/usr/local/sbin:/sbin:$PATH"
export GIT_CLEAR_BRANCH_EXCLUDE="release|develop|master|development|staging"
export fpath=( $HOME/.autoload-zsh $DOTFILES/rcfiles/zsh/functions/completions $fpath )
export VSCODE_FILE=$HOME/.vscode-cli
export GPG_TTY=$(tty)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig/:/usr/share/pkgconfig:/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
export JAVA_HOME="/usr/java/latest"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export HOMEBREW_NO_AUTO_UPDATE=1
export LANG=en_US.UTF-8
export LANGUAGE=$LANG
export LC_ALL=$LANG

if type gnome-keyring-daemon &> /dev/null; then
  dbus-update-activation-environment --systemd DISPLAY
  eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg 2> /dev/null)
  export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
fi
