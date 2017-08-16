pj () {
  cd "$PROJECTS/$@"
}

_fn_pj_option_list() {
  local dir max
  dir="$@"
  max=1
  local IFS=$'\n'
  if [ "$dir" != "" ] && [ ! -d "$PROJECTS/$dir/" ]; then
    dir=$(dirname $PROJECTS/$dir | rg "(${PROJECTS})/?(.+)" --replace '$2')
  fi
  dir="$([ "$dir" != "" ] && echo "$dir" | rg '(.+)/?$' --replace '$1' || echo "")"
  [ "$dir" = "" ] && max=2
  find $PROJECTS/$dir -maxdepth $max -type d -exec bash -c 'printf "%q\n" "$@"' printf {} ';' | \
    rg "${PROJECTS}/?${dir}/?(.+)" --replace '$1'
}

_fzf_complete_pj() {
  _fzf_complete "$FZF_DEFAULT_OPTS" "$@" < <(
    _fn_pj_option_list
  )
  zle accept-line
}
