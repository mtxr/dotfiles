function autoswitch_node() {
    emulate -L zsh
    [ -f "$PWD/package.json" ] && n auto
}

chpwd_functions=(${chpwd_functions[@]} "autoswitch_node")