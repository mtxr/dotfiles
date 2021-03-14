LOAD_TYPE= #light-mode

zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" zdharma/fast-syntax-highlighting \
    blockf zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" zsh-users/zsh-autosuggestions

zinit for \
    $LOAD_TYPE lukechilds/zsh-better-npm-completion \
    $LOAD_TYPE mtxr/lwd \
    $LOAD_TYPE mtxr/zsh-change-case \
    $LOAD_TYPE djui/alias-tips \
    $LOAD_TYPE caarlos0/ports \
    $LOAD_TYPE zsh-users/zsh-history-substring-search \
    $LOAD_TYPE mtxr/per-directory-history
