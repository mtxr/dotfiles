# External plugins (initialized before)

##############################
# Zplug                      #
##############################
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

##############################
# Mtxr tools auto install    #
##############################
zplug "$HOME/.zsh/plugins/auto-install/auto-installer.zsh", from:local
