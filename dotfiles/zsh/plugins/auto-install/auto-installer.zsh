export WEB_INSTALLER=$(type wget &> /dev/null && echo "wget -qO-" || echo "curl -L")
export OS_PKG_INSTALLER=$(type brew &> /dev/null && echo "brew install" || echo "sudo apt-get install")
export N_PREFIX=$([ "$N_PREFIX" = "" ] && echo $HOME/n || echo $N_PREFIX)

if [[ ! -e $N_PREFIX ]]; then
    echo 'Will install N, the node version manager...'
    eval $WEB_INSTALLER https://git.io/n-install | N_PREFIX=$N_PREFIX bash -s -- -y -n && echo "Installed!" || echo "##### Failed to install 'N'."
fi

if ! type yarn &> /dev/null; then
    echo "Installing 'yarn'..."
    npm install -g yarn &> /dev/null && echo "Installed!" || echo "##### Failed to install 'yarn'."
fi

if ! type diff-so-fancy &> /dev/null; then
    echo "Installing 'diff-so-fancy'..."
    yarn global add diff-so-fancy &> /dev/null && echo "Installed!" || echo "##### Failed to install 'diff-so-fancy'."
fi
