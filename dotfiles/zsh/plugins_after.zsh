# External plugins (initialized after)

# dircolors
export CLICOLOR=1   # dircolors doesn`t run on mac. Use CLICOLOR.
if [[ "$(tput colors)" == "256" && -e "$(which dircolors)" ]]; then
    eval $(dircolors =(cat ~/.zsh/plugins/dircolors-solarized/dircolors.256dark ~/.zsh/dircolors.extra))
fi

. $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

k() {
    unset -f k
    . $HOME/.zsh/plugins/k/k.sh
    k $@
}

if [[ ! -e $HOME/.nvm ]]; then
    echo 'Will install nvm...'
    if hash wget &> /dev/null ; then
        wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
    else
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
    fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
