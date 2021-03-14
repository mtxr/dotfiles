#!/usr/bin/zsh

chsh -s $(which zsh)


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

##############################
# tools auto install    #
##############################
if [[ ! -d "$N_PREFIX" ]]; then
  echo 'Will install N, the node version manager...' && \
  eval $WEB_INSTALLER https://git.io/n-install | N_PREFIX=$N_PREFIX bash -s -- -y -n || echo "##### Failed to install 'N'."

  zsh -c "npm install -g yarn"

fi

TO_INSTALL=""
type diff-so-fancy &> /dev/null || TO_INSTALL="$TO_INSTALL diff-so-fancy"

if [ "$TO_INSTALL" != "" ]; then
  echo "Installing '$TO_INSTALL'..."
  eval "npm install -g $TO_INSTALL" > /dev/null || (echo "##### Failed to install '$TO_INSTALL'" && exit 1)
fi

if [ ! -f $HOME/.fzf.zsh ]; then
  $(brew --prefix)/opt/fzf/install --no-update-rc <<EOF
y
EOF
fi
[ -f $HOME/.fzf.zsh ] && . $HOME/.fzf.zsh

if ! type mdv &> /dev/null; then
  echo "Installing 'mdv'..."
  pip3 install --user mdv
fi

[ ! -d $HOME/.autoload-zsh ] && mkdir -p $HOME/.autoload-zsh
if [ ! -f "$HOME/.autoload-zsh/_fzf_compgen_path" ]; then
  echo "#! /usr/bin/env zsh" > $HOME/.autoload-zsh/_fzf_compgen_path
  declare -f _fzf_compgen_path >> $HOME/.autoload-zsh/_fzf_compgen_path
fi

if [ ! -f "$HOME/.autoload-zsh/_fzf_compgen_dir" ]; then
  echo "#! /usr/bin/env zsh" > $HOME/.autoload-zsh/_fzf_compgen_dir
  declare -f _fzf_compgen_dir >> $HOME/.autoload-zsh/_fzf_compgen_dir
fi
set +e

unset TO_INSTALL
[ ! -d $HOME/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

