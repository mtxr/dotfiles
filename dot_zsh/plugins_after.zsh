# External plugins (initialized after)
if command -v sk &> /dev/null; then
  # Set up skim key bindings and fuzzy completion
  source <(sk --shell zsh)

  if command -v brew &> /dev/null; then
    [[ -f $(brew --prefix)/opt/sk/share/zsh/site-functions/key-bindings.zsh ]] && source $(brew --prefix)/opt/sk/share/zsh/site-functions/key-bindings.zsh

  elif [ -d /usr/share/skim ]; then
    [[ -f /usr/share/skim/key-bindings.zsh ]] && source /usr/share/skim/key-bindings.zsh
    [[ -f /usr/share/skim/completion.zsh ]] && source /usr/share/skim/completion.zsh
  fi
fi

# Initialize zoxide if installed
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
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
