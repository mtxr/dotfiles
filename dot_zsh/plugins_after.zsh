# External plugins (initialized after)

[ -f $HOME/.fzf.zsh ] && . $HOME/.fzf.zsh

export ZSH_HIGHLIGHT_MAXLENGTH=100
export HISTORY_START_WITH_GLOBAL=true

. $HOME/.zinit/bin/zinit.zsh

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

. $HOME/.zsh/hooks/cd.zsh