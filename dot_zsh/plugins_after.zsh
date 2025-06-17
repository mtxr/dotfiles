# External plugins (initialized after)
if command -v fzf &> /dev/null; then
  # Set up fzf key bindings and fuzzy completion
  source <(fzf --zsh)
fi

export ZSH_HIGHLIGHT_MAXLENGTH=100

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

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
