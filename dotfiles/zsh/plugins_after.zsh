# External plugins (initialized after)

# dircolors
export CLICOLOR=1   # dircolors doesn`t run on mac. Use CLICOLOR.
if [[ "$(tput colors)" == "256" && -e "$(which dircolors)" ]]; then
  eval $(dircolors =(cat ~/.zsh/plugins/dircolors-solarized/dircolors.256dark ~/.zsh/dircolors.extra))
fi

export ZSH_HIGHLIGHT_MAXLENGTH=100

if [ ! -f "$HOME/.zsh-plugins" ];then
  ##############################
  # Syntax highlighting        #
  ##############################
  # echo "zsh-users/zsh-syntax-highlighting" > $HOME/.zsh-plugins
  echo "zdharma/fast-syntax-highlighting" > $HOME/.zsh-plugins

  ##############################
  # ZSH history search         #
  ##############################
  echo "zsh-users/zsh-history-substring-search" >> $HOME/.zsh-plugins

  ##############################
  # zsh-better-npm-completion  #
  ##############################
  echo "lukechilds/zsh-better-npm-completion" >> $HOME/.zsh-plugins

  ##############################
  # ZSH Autosuggestions        #
  ##############################
  echo "zsh-users/zsh-autosuggestions" >> $HOME/.zsh-plugins

  ##############################
  # ZSH Autosuggestions        #
  ##############################
  echo "zsh-users/zsh-completions" >> $HOME/.zsh-plugins

  ##############################
  # ZSH LWD                    #
  ##############################
  echo "mtxr/lwd" >> $HOME/.zsh-plugins

  ##############################
  # ZSH Change Case            #
  ##############################
  echo "mtxr/zsh-change-case" >> $HOME/.zsh-plugins

  ##############################
  # ZSH ALIAS Tips             #
  ##############################
  echo "djui/alias-tips" >> $HOME/.zsh-plugins

  ##############################
  # ZSH interactive CD         #
  ##############################
  echo "changyuheng/zsh-interactive-cd" >> $HOME/.zsh-plugins

  ##############################
  # ZSH geometry theme         #
  ##############################
  echo "geometry-zsh/geometry" >> $HOME/.zsh-plugins
fi

antibody bundle < $HOME/.zsh-plugins

bindkey -r '^K'
bindkey '^K^U' _mtxr-to-upper
bindkey '^K^L' _mtxr-to-lower

