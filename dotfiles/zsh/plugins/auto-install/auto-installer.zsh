if [ "$(uname)" = "Linux" ] && ! type brew &> /dev/null; then
  echo "Installing linuxbrew..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  hash -r
fi

export WEB_INSTALLER=${WEB_INSTALLER:-$(type wget &> /dev/null && echo "wget -qO-" || echo "curl -L")}
export OS_INSTALLER=$(type brew &> /dev/null && echo "brew install -f" || echo "sudo apt-get install -y")
export N_PREFIX=${N_PREFIX:-"$HOME/.n"}
export PATH="$N_PREFIX/bin:$PATH"

TO_INSTALL=""

type tmux &> /dev/null || TO_INSTALL="$TO_INSTALL tmux"
type hub &> /dev/null || TO_INSTALL="$TO_INSTALL hub"
type rg &> /dev/null || TO_INSTALL="$TO_INSTALL ripgrep"

if [ "$TO_INSTALL" != "" ]; then
  echo "Installing '$TO_INSTALL'..." && \
  eval $OS_INSTALLER $TO_INSTALL > /dev/null
fi

if [[ ! -d "$N_PREFIX" ]]; then
  echo 'Will install N, the node version manager...' && \
  eval $WEB_INSTALLER https://git.io/n-install | N_PREFIX=$N_PREFIX bash -s -- -y -n || echo "##### Failed to install 'N'."
fi

TO_INSTALL=""

type yarn &> /dev/null || TO_INSTALL="$TO_INSTALL yarn"
type diff-so-fancy &> /dev/null || TO_INSTALL="$TO_INSTALL diff-so-fancy"

if [ "$TO_INSTALL" != "" ]; then
  echo "Installing '$TO_INSTALL'..."
  eval "npm install -g $TO_INSTALL" > /dev/null || (echo "##### Failed to install '$TO_INSTALL'" && exit 1)
fi

if ! type fzf &> /dev/null; then
  echo "Installing 'fzf'..." && \
  eval $OS_INSTALLER fzf > /dev/null && \
  $(brew --prefix)/opt/fzf/install --no-update-rc <<EOF
y
y
n
EOF
fi
. $HOME/.fzf.zsh

if ! type pv &> /dev/null; then
  echo "Installing 'pv'..."
  if [ "$(uname)" = "Linux" ];then
    sudo apt-get install pv
  else
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
