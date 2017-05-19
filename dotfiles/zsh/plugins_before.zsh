# External plugins (initialized before)

# Check auto installs
. $HOME/.zsh/plugins/auto-install/auto-installer.zsh
. $HOME/.zsh/plugins/lwd/bin/lwd.sh

# zsh-completions
fpath=($HOME/.zsh/plugins/zsh-completions/src $fpath)
