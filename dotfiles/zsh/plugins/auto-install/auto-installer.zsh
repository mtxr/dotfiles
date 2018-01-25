export WEB_INSTALLER=${WEB_INSTALLER:-$(type wget &> /dev/null && echo "wget -qO-" || echo "curl -L")}
export OS_PKG_INSTALLER=$(type brew &> /dev/null && echo "brew install" || echo "sudo apt-get install")
export N_PREFIX=${N_PREFIX:-"$HOME/.n"}
export PATH="$N_PREFIX/bin:$PATH"

if [[ ! -d "$N_PREFIX" ]]; then
  echo 'Will install N, the node version manager...' && \
  eval $WEB_INSTALLER https://git.io/n-install | N_PREFIX=$N_PREFIX bash -s -- -y -n || echo "##### Failed to install 'N'."
fi

if ! type yarn &> /dev/null; then
  echo "Installing 'yarn'..." && \
  npm install -g yarn &> /dev/null || echo "##### Failed to install 'yarn'."
fi

if ! type diff-so-fancy &> /dev/null; then
  echo "Installing 'diff-so-fancy'..." && \
  npm i -g diff-so-fancy &> /dev/null || echo "##### Failed to install 'diff-so-fancy'."
fi

if ! type rg &> /dev/null; then
  echo "Installing 'ripgrep'..." && \
  brew install ripgrep
fi

if ! type fzf &> /dev/null; then
  echo "Installing 'fzf'..." && \
  brew install fzf && \
  /usr/local/opt/fzf/install --no-update-rc < /dev/null
fi
. $HOME/.fzf.zsh

if ! type pv &> /dev/null; then
  echo "Installing 'pv'..."
  CUR_PWD=$(pwd)
  eval $WEB_INSTALLER "http://www.ivarch.com/programs/sources/pv-1.6.6.tar.bz2" > /tmp/pv-src.tar.bz2 && \
  tar -jxvf /tmp/pv-src.tar.bz2 -C /tmp && \
  builtin cd /tmp/pv-1.6.6 && \
  ./configure && \
  make && \
  make install && \
  pv --version
  builtin cd $CUR_PWD
fi

if ! type hub &> /dev/null; then
  echo "Installing 'hub'..."
  brew install hub
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
