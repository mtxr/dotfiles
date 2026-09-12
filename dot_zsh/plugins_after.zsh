# External plugins (initialized after)

# antidote first: it brings zsh-defer, used to defer the spawns below.
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

antidote load $HOME/.zsh_plugins.txt

export ZSH_HIGHLIGHT_MAXLENGTH=100

# skim (sk): completions + key bindings from the binary itself.
if command -v sk &> /dev/null; then
  zsh-defer eval 'source <(sk --shell zsh --shell-bindings)'
elif [ -d /usr/share/skim ]; then
  zsh-defer eval '[[ -f /usr/share/skim/key-bindings.zsh ]] && source /usr/share/skim/key-bindings.zsh; [[ -f /usr/share/skim/completion.zsh ]] && source /usr/share/skim/completion.zsh'
fi

# Initialize zoxide if installed
if command -v zoxide &> /dev/null; then
  zsh-defer eval 'eval "$(zoxide init zsh)"'
fi
