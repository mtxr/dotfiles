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
  # ZSH ALIAS Tips             #
  ##############################
  echo "djui/alias-tips" >> $HOME/.zsh-plugins

  ##############################
  # ZSH interactive CD         #
  ##############################
  echo "changyuheng/zsh-interactive-cd" >> $HOME/.zsh-plugins

  ##############################
  # ZSH fzf-widgets            #
  ##############################
  echo 'ytet5uy4/fzf-widgets' >> $HOME/.zsh-plugins
fi

antibody bundle < $HOME/.zsh-plugins

# Map widgets to key
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^@@' fzf-select-widget
bindkey '^@.' fzf-edit-dotfiles
bindkey '^@c' fzf-change-directory
bindkey '^@f' fzf-edit-files
bindkey '^@k' fzf-kill-processes
bindkey '^@s' fzf-exec-ssh
bindkey '^\'  fzf-change-recent-directory
bindkey '^r'  fzf-insert-history
bindkey '^xf' fzf-insert-files
bindkey '^xd' fzf-insert-directory

## Git
bindkey '^@g'  fzf-select-git-widget
bindkey '^@ga' fzf-git-add-files
bindkey '^@gc' fzf-git-change-repository

# GitHub
bindkey '^@h'  fzf-select-github-widget
bindkey '^@hs' fzf-github-show-issue
bindkey '^@hc' fzf-github-close-issue

## Docker
bindkey '^@d'  fzf-select-docker-widget
bindkey '^@dc' fzf-docker-remove-containers
bindkey '^@di' fzf-docker-remove-images
bindkey '^@dv' fzf-docker-remove-volumes

# completion key binding
fzf-completion-no-trigger-key () {
  FZF_COMPLETION_TRIGGER='' fzf-completion
}
zle -N fzf-completion-no-trigger-key

bindkey '^P' fzf-completion-no-trigger-key
bindkey '^F' fzf-completion-no-trigger-key
