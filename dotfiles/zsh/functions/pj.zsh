pj () {
  cd "$PROJECTS/$@"
}

_fn_pj_option_list() {
  local max=${MAX:-4}
  local IFS=$'\n'
  echo "Project"
  rg --files --maxdepth $max $PROJECTS | xargs dirname | rg "$PROJECTS/" --replace '' | sort -u
}

_fzf_complete_pj() {
  _fzf_complete "$FZF_DEFAULT_OPTS --header-lines=1" "$@" < <(
    _fn_pj_option_list
  )
}

_fzf_complete_pj_post() {
  cat
  zle accept-line
}
