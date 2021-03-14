pj () {
  cd "$PROJECTS/$@"
}

_fn_pj_option_list() {
  local max=${MAX:-3}
  local IFS=$'\n'
  # rg --files --max-depth $max $PROJECTS | xargs -I {} dirname {} | sort -u -f | rg "$PROJECTS/" --replace ''
  fd -L -t d '' $PROJECTS | rg "$PROJECTS/" --replace ''
}

_fzf_complete_pj() {
  _fzf_complete "$FZF_DEFAULT_OPTS --header-lines=1" "$@" < <(
    {echo "Project";_fn_pj_option_list}
  )
}

_fzf_complete_pj_post() {
  cat
  zle accept-line
}
