
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

[ ! -d $HOME/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
