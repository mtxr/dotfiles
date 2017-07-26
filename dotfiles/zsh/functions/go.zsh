go () {
  cd "$PROJECTS/$@"
}

_fn_go_option_list() {
  local cur dir opts max
  dir="$@"
  max=1
  local IFS=$'\n'
  if [ "$dir" != "" ] && [ ! -d "$PROJECTS/$dir" ]; then
    dir=$(dirname $PROJECTS/$dir | sed 's|'$PROJECTS/'||g' | sed 's|'$PROJECTS'||g')
    max=1
  fi
  declare -a _go_options
  _go_options=( $(find $PROJECTS/$dir -maxdepth $max -type d -exec bash -c 'printf "%q\n" "$@"' printf {} ';' | sed 's|'$PROJECTS/$dir/'||g' | sed 's|'$PROJECTS/$dir'||g') )
  printf '%s\n' "${_go_options[@]}"
}

_fn_go_completion() {
  local dir="$@"
  local query=""
  local selected

  selected=$(
    FZF_DEFAULT_OPTS="--reverse $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS --bind 'shift-tab:up,tab:down'" \
    fzf -1 -q "$query" < <( _fn_go_option_list $dir )
  )
  if [ "$selected" = "" ]; then
    zle redisplay
    return 0
  fi
  LBUFFER="$(printf "go %q" "${dir}${selected}/")"
  zle redisplay
}

_fn_go_complete() {
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
  local tokens cmd
  tokens=(${(z)LBUFFER})
  cmd=${tokens[1]}
  if [[ "$LBUFFER" =~ "^\ *go$" ]]; then
    zle ${_fn_go_default_completion:-expand-or-complete}
  elif [ "$cmd" = go ]; then
    _fn_go_completion ${tokens[2,${#tokens}]}
  else
    zle ${_fn_go_default_completion:-expand-or-complete}
  fi
}

[ -z "$_fn_go_default_completion" ] && {
  binding=$(bindkey '^I')
  [[ $binding =~ 'undefined-key' ]] || _fn_go_default_completion=$binding[(s: :w)2]
  unset binding
}

zle -N _fn_go_complete
bindkey '^I' _fn_go_complete
