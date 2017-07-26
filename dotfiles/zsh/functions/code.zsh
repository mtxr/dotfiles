if type code &> /dev/null; then
  vscode=$(which code)
  code () {
    local args="$@"
    args=${args:-'.'}
    eval $vscode -r $args || return 1
    return 0
  }
fi
