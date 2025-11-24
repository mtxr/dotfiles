_fn_wk_option_list() {
  local max="${MAX:-2}"
  local IFS=$'\n'
  (cd "$WORK_DIR" 2>/dev/null && fd --exclude '.git' -L -d "$max" -H -t d '')
}

wk () {
  # If called without args, open skim to choose
  if [[ -z "$1" ]]; then
    local choice
    choice=$(_fn_wk_option_list | SKIM_DEFAULT_OPTIONS="${SKIM_DEFAULT_OPTIONS} --header 'Project'" sk --no-sort --preview "exa -l --colour=always {}" 2>/dev/null)
    [[ -n "$choice" ]] && cd "$WORK_DIR/$choice"
    return
  fi

  cd "$WORK_DIR/$@"
}

_skim_complete_wk() {
  _skim_generic_complete "$SKIM_DEFAULT_OPTIONS --header-lines=1 --layout default" "$@" < <(
    {echo "Project";_fn_wk_option_list}
  )
}

compdef _skim_complete_wk wk



alias pj=wk

[ -d ~/projects ] && [ ! -d $WORK_DIR ] && mv ~/projects $WORK_DIR
[ -L ~/projects ] && [ ! -d $WORK_DIR ] && mv ~/projects $WORK_DIR

npj() {
  if [ -z "$1" ]; then
    echo "Usage: npj <project-name>"
    return 1
  fi

  local project_dir="$WORK_DIR/$1"

  if [ -d "$project_dir" ]; then
    echo "Project directory already exists: $project_dir"
    return 1
  fi

  mkdir -p "$project_dir"
  cd "$project_dir"
  git init
  echo "Created and initialized project at: $project_dir"
}
