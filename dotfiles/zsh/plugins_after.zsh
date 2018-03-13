# External plugins (initialized after)

# dircolors
export CLICOLOR=1   # dircolors doesn`t run on mac. Use CLICOLOR.
if [[ "$(tput colors)" == "256" && -e "$(which dircolors)" ]]; then
  eval $(dircolors =(cat $HOME/.zsh/plugins/dircolors-solarized/dircolors.256dark $HOME/.zsh/dircolors.extra))
fi

export ZSH_HIGHLIGHT_MAXLENGTH=100
if [ ! -f "$HOME/.zsh-plugins.sh" ] || \
   [ ! -s "$HOME/.zsh-plugins.sh" ] || \
   [ "$(( (`date +%s` - `date -r $HOME/.zsh-plugins.sh +%s`) / 86400 ))" -gt 5 ]
then
  echo "Updating plugins..."
  antibody bundle < $WORKSTATION/dotfiles/antibody-plugins.txt > $HOME/.zsh-plugins.sh
  antibody update
  touch $HOME/.zsh-plugins.sh
fi

. $HOME/.zsh-plugins.sh

# Remove conflicting keybindings
bindkey -r '^K'
bindkey -r '^T'

# registering ZSH-change case hotkeys
bindkey '^K^U' _mtxr-to-upper
bindkey '^K^L' _mtxr-to-lower

