# External plugins (initialized after)

# skim (sk): completions + key bindings from the binary itself.
# Works whether sk comes from mise (aqua:skim-rs/skim) or anywhere else on PATH.
if command -v sk &> /dev/null; then
  source <(sk --shell zsh --shell-bindings)
elif [ -d /usr/share/skim ]; then
  # Distro package fallback (Linux)
  [[ -f /usr/share/skim/key-bindings.zsh ]] && source /usr/share/skim/key-bindings.zsh
  [[ -f /usr/share/skim/completion.zsh ]] && source /usr/share/skim/completion.zsh
fi

# Initialize zoxide if installed
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

export ZSH_HIGHLIGHT_MAXLENGTH=100

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

antidote load $HOME/.zsh_plugins.txt
