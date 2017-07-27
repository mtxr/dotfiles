if type code &> /dev/null; then
  export original_vscode=${original_vscode:-$(which code)}
  code () {
    local args=""
    while test $# -gt 0
    do
      if [ -d "$1" ]; then
        args="$args \"$1\""
      elif [ -f "$1" ] && [[ "$args" =~ " -r " ]]; then
        args="$args \"$1\""
      elif [ -f "$1" ]; then
        args="$args -r \"$1\""
      else
        args="$args $1"
      fi
      shift
    done
    args=${args:-'.'}
    eval $original_vscode "$args" || return 1
    return 0
  }
fi
