wk () {
  cd "$WORK_DIR/$@"
}

_fn_wk_option_list() {
  local max=${MAX:-3}
  local IFS=$'\n'
  # rg --files --max-depth $max $WORK_DIR | xargs -I {} dirname {} | sort -u -f | rg "$WORK_DIR/" --replace ''
  fd -L -t d '' $WORK_DIR | rg "$WORK_DIR/" --replace ''
}

_fzf_complete_wk() {
  _fzf_complete "$FZF_DEFAULT_OPTS --header-lines=1" "$@" < <(
    {echo "Project";_fn_wk_option_list}
  )
}

_fzf_complete_wk_post() {
  cat
  zle accept-line
}

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
