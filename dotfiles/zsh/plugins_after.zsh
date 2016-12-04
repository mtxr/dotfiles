# External plugins (initialized after)

# dircolors
if [[ "$(tput colors)" == "256" && -e "$(which dircolors)" ]]; then
    eval $(dircolors =(cat ~/.zsh/plugins/dircolors-solarized/dircolors.256dark ~/.zsh/dircolors.extra))
fi

source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.zsh/plugins/k/k.sh

test -e /usr/local/opt/nvm/nvm.sh && . /usr/local/opt/nvm/nvm.sh
