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