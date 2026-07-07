_fn_wk_option_list() {
  local max="${MAX:-3}"
  local IFS=$'\n'
  (cd "$CODE_DIR" 2>/dev/null && fd --exclude '.git' -L -d "$max" -H -t d '')
}

_fn_wk_pretty_path() {
  local path="$CODE_DIR/$1"
  echo "${path/#$HOME/~}"
}

wk () {
  local -a target_cmd=("cd")

  while [[ "$1" == -* ]]; do
    case "$1" in
      -e) target_cmd=(${=VISUAL:-zed}); shift ;;
      -p) target_cmd=("echo"); shift ;;
      *) break ;;
    esac
  done

  local target
  if [[ -z "$1" ]]; then
    target=$(_fn_wk_option_list | SKIM_DEFAULT_OPTIONS="${SKIM_DEFAULT_OPTIONS} --header 'Project'" sk --no-sort --preview "eza --tree --color=always -A --icons=always $CODE_DIR/{}")
    [[ -z "$target" ]] && return
  else
    target="$1"
  fi

  if [[ "$target_cmd[1]" == "echo" ]]; then
    _fn_wk_pretty_path "$target"
  else
    "${target_cmd[@]}" "$CODE_DIR/$target"
  fi
}

_skim_complete_wk() {
  _skim_generic_complete "$SKIM_DEFAULT_OPTIONS --header-lines=1 --layout default" "$@" < <(
    {echo "Project";_fn_wk_option_list}
  )
}

compdef _skim_complete_wk wk
zle -N _skim_complete_wk

[ -d ~/work ] && [ ! -d $CODE_DIR ] && mv ~/work $CODE_DIR
[ ! -d $CODE_DIR/personal ] && mkdir -p $CODE_DIR/personal
[ ! -d $CODE_DIR/work ] && mkdir -p $CODE_DIR/work
[ ! -d $CODE_DIR/sandbox ] && mkdir -p $CODE_DIR/sandbox
