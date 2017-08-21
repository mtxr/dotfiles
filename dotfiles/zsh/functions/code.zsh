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

_fzf_complete_code() {
  ARGS="$@"
  if [[ "$ARGS" =~ '^ *code *$' ]];then
    _fzf_complete "$FZF_DEFAULT_OPTS --header-lines=1" "$@" < <(
      _fn_pj_option_list
    )
  else
    eval "zle ${fzf_default_completion:-expand-or-complete}"
  fi
}

_fzf_complete_code_post() {
  rg '^ *(.+) *$' --replace ''$PROJECTS'/$1' | rg "^$HOME(/.+)$" --replace '~$1'
}
