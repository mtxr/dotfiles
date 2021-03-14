# External plugins (initialized after)

# dircolors
export CLICOLOR=1   # dircolors doesn`t run on mac. Use CLICOLOR.
if [[ "$(tput colors)" == "256" && -e "$(which dircolors)" && -f $HOME/.zsh/dircolors-solarized/dircolors.ansi-dark ]]; then
  eval $(dircolors =(cat $HOME/.zsh/dircolors-solarized/dircolors.ansi-dark $HOME/.zsh/dircolors.extra))
fi

export ZSH_HIGHLIGHT_MAXLENGTH=100
export HISTORY_START_WITH_GLOBAL=true


. $HOME/.zsh/zinit-plugins-load.zsh

# Remove conflicting keybindings
bindkey -r '^K'
bindkey -r '^T'

# registering ZSH-change case hotkeys
bindkey '^K^U' _mtxr-to-upper
bindkey '^K^L' _mtxr-to-lower

autoload -U zcalc
function __calc_plugin {
    zcalc -e "$*"
}
aliases[calc]='noglob __calc_plugin'
aliases[=]='noglob __calc_plugin'
