export N_PREFIX=$([ "$N_PREFIX" = "" ] && echo $HOME/n || echo $N_PREFIX)

if [[ ! -e $N_PREFIX ]]; then
    echo 'Will install N, the node version manager...'
    INSTALLER=$(hash wget &> /dev/null && echo "wget -qO-" || echo "curl -L")
    eval $INSTALLER https://git.io/n-install | N_PREFIX=$N_PREFIX bash -s -- -y -n
fi
