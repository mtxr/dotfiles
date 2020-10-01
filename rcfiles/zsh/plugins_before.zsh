# External plugins (initialized before)
export WEB_INSTALLER=${WEB_INSTALLER:-$(type wget &> /dev/null && echo "wget -qO-" || echo "curl -L")}

##############################
# Starship prompt            #
##############################

if ! type starship &> /dev/null; then
  eval $WEB_INSTALLER https://starship.rs/install.sh | bash
fi

##############################
# ZINIT                      #
##############################
if [ ! -d $HOME/.zinit/bin ]; then
  mkdir -p $HOME/.zinit
  git clone https://github.com/zdharma/zinit.git $HOME/.zinit/bin
fi
source $HOME/.zinit/bin/zinit.zsh

##############################
# Mtxr tools auto install    #
##############################
. "$HOME/.zsh/plugins/auto-install/auto-installer.zsh"

[ -f "${HOME}/.iterm2_shell_integration.zsh" ] && . "${HOME}/.iterm2_shell_integration.zsh"
