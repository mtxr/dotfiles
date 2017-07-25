# External plugins (initialized after)

# dircolors
export CLICOLOR=1   # dircolors doesn`t run on mac. Use CLICOLOR.
if [[ "$(tput colors)" == "256" && -e "$(which dircolors)" ]]; then
    eval $(dircolors =(cat ~/.zsh/plugins/dircolors-solarized/dircolors.256dark ~/.zsh/dircolors.extra))
fi
##############################
# Syntax highlighting        #
##############################
zplug "zdharma/fast-syntax-highlighting"

##############################
# ZSH history search         #
##############################
zplug "zsh-users/zsh-history-substring-search"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

##############################
# zsh-better-npm-completion  #
##############################
zplug "lukechilds/zsh-better-npm-completion", defer:2

##############################
# ZSH Autosuggestions        #
##############################
zplug "zsh-users/zsh-autosuggestions"

##############################
# ZSH Autosuggestions        #
##############################
zplug "zsh-users/zsh-completions"

##############################
# ZSH LWD                    #
##############################
zplug "mtxr/lwd", as:plugin, use:lwd.sh

##############################
# ZSH ALIAS Tips             #
##############################
zplug "djui/alias-tips"

##############################
# ZSH interactive CD         #
##############################
zplug "changyuheng/zsh-interactive-cd", use:zsh-interactive-cd.plugin.zsh

##############################
# ZSH fzf-widgets            #
##############################
zplug 'ytet5uy4/fzf-widgets'
if zplug check 'ytet5uy4/fzf-widgets'; then
  # Map widgets to key
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
 fi
