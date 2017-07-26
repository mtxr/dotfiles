go () {
  cd "$PROJECTS/$@"
}

_fn_go_option_list() {
  local cur dir opts max
  dir="$@"
  max=2
  local IFS=$'\n'
  if [ "$dir" != "" ] && [ ! -d "$PROJECTS/$dir/" ]; then
    dir=$(dirname $PROJECTS/$dir | rg "(${PROJECTS})/?(.+)" --replace '$2')
    max=1
  fi
  dir="$([ "$dir" != "" ] && echo "$dir" | rg '(.+)(/)?$' --replace '$1' || echo "")"
  rg --files --maxdepth=2 $PROJECTS/$dir  | \
    xargs -I{} dirname {} | \
    rg "(${PROJECTS}/?${dir})/?(.+)" --replace '$2' | \
    sort | uniq
}

_fn_go_completion() {
  local dir="$@"
  local query=""
  local selected

  if [ "$dir" != "" ] && [ ! -d "$PROJECTS/$dir/" ]; then
    query="$(basename $dir)"
    dir=$(dirname $PROJECTS/$dir | rg "(${PROJECTS})/?(.+)" --replace '$2')
  fi

  dir="$dir/"
  [ "$dir" = "/" ] && dir=""

  selected=$(
    FZF_DEFAULT_OPTS="--reverse --cycle $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS --bind 'shift-tab:up,tab:down'" \
    fzf -1 -q "$query" < <( _fn_go_option_list $dir )
  )
  if [ "$selected" = "" ]; then
    zle redisplay
    return 0
  fi

  LBUFFER="$(printf "go %q" "$(echo ${dir}${selected} | sed 's|//|/|g')/")"
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
