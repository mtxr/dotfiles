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
export NVM_LOADED=false
lazy_load_nodef() {
    FUNC=$1
    shift
    if [ $NVM_LOADED = false ];then
        NVM_FILE=${NVM_FILE:-"/usr/local/opt/nvm/nvm.sh"}
        [ ! -f "$NVM_FILE" ] && echo "You should install nvm first" && return 1
        echo "Loading NVM..."
        unset -f npm node nvm
        export NVM_DIR="$HOME/.nvm"
        . $NVM_FILE
        export NVM_LOADED=true
    fi
    $FUNC $@
}

nvm() {
    lazy_load_nodef nvm $@
}

node() {
    lazy_load_nodef node $@
}

npm() {
    lazy_load_nodef npm $@
}
