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


# Load powerlevel9k
[ "$ZSH_THEME" = "powerlevel" ] && . $HOME/.zsh/plugins/powerlevel9k/powerlevel9k.zsh-theme
