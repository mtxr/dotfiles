export VSCODE_CLI=$(/bin/cat $VSCODE_FILE)

if type "$VSCODE_CLI" &> /dev/null; then
  export ORIGINAL_VSCODE=${ORIGINAL_VSCODE:-$(which $VSCODE_CLI)}
  code () {
    local args=""
    while test $# -gt 0
    do
      if [ -d "$1" ]; then
        local workspace=$(ls -1 `realpath $1` | rg -e "\.code-workspace$" | head -n 1)
        if [[ "$workspace" != "" ]] && [ -f "$workspace" ]; then
          args="$args \"`realpath $workspace`\""
        else
          args="$args \"$1\""
        fi
      elif [ -f "$1" ] && [[ "$args" = *"-r"* ]]; then
        args="$args \"$1\""
      elif [ -f "$1" ]; then
        args="$args -r \"$1\""
      else
        args="$args $1"
      fi
      shift
    done
    args=${args:-'.'}
    eval $ORIGINAL_VSCODE "$args" || return 1
    return 0
  }
  _fzf_complete_code() {
    ARGS="$@"
    if [[ "$ARGS" =~ '^ *code *$' ]];then
      _fzf_complete "$FZF_DEFAULT_OPTS --header-lines=1" "$@" < <(
        _fn_wk_option_list
      )
    else
      eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
  }

  _fzf_complete_code_post() {
    rg '^ *(.+) *$' --replace ''$WORK_DIR'/$1' | rg "^$HOME(/.+)$" --replace '~$1'
  }
fi

if ! type code &> /dev/null; then
  alias code="$VSCODE_CLI"
fi
