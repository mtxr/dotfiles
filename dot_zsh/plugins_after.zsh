# External plugins (initialized after)

[ -f $HOME/.fzf.zsh ] && . $HOME/.fzf.zsh

export ZSH_HIGHLIGHT_MAXLENGTH=100
export HISTORY_START_WITH_GLOBAL=true

## zinit
. "$HOME/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

. $HOME/.zsh/zinit-plugins-load.zsh
## zinit end

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
