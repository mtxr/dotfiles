export N_PREFIX=$([ "$N_PREFIX" = "" ] && echo $HOME/n || echo $N_PREFIX)

if [[ ! -e $N_PREFIX ]]; then
    echo 'Will install N, the node version manager...'
    INSTALLER=$(type wget &> /dev/null && echo "wget -qO-" || echo "curl -L")
    eval $INSTALLER https://git.io/n-install | N_PREFIX=$N_PREFIX bash -s -- -y -n
fi

if [[ "$(type yarn &> /dev/null && echo $?)" = "1" ]]; then
    echo "Installing 'yarn'..."
    npm install -g yarn &> /dev/null && echo "Installed!" || echo "##### Failed to install 'yarn'."
fi

if [[ "$(type diff-so-fancy &> /dev/null && echo $?)" = "1" ]]; then
    echo "Installing 'diff-so-fancy'..."
    yarn global add diff-so-fancy &> /dev/null && echo "Installed!" || echo "##### Failed to install 'diff-so-fancy'."
fi
