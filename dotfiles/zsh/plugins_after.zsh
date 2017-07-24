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
