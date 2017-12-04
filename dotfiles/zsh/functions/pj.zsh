pj () {
  cd "$PROJECTS/$@"
}

_fn_pj_option_list() {
  local max=${MAX:-3}
  local IFS=$'\n'
  echo "Project"
  find $PROJECTS/ -maxdepth $max -type d ! -path '*.svn' ! -path '*.git' -exec bash -c 'printf "%q\n" "$@"' printf {} ';' | \
    rg "^${PROJECTS}/*(.+)$" --replace '$1'
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
