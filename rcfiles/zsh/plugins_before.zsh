# External plugins (initialized before)
export WEB_INSTALLER=${WEB_INSTALLER:-$(type wget &> /dev/null && echo "wget -qO-" || echo "curl -L")}

##############################
# Antibody                   #
##############################
if ! type antibody &> /dev/null; then
  eval $WEB_INSTALLER https://git.io/antibody | bash -s && \
fi

##############################
# Mtxr tools auto install    #
##############################
. "$HOME/.zsh/plugins/auto-install/auto-installer.zsh"

[ -f "${HOME}/.iterm2_shell_integration.zsh" ] && . "${HOME}/.iterm2_shell_integration.zsh"
