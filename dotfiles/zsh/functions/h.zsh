function h() {
  dir=$(join / $@)
  cd $HOME/$dir
}

_fn_render_h_selection() {
  local dir="$HOME/$(join / $@)"
  local query
  local selected
  if [ ! -d "$dir" ];then
    query="$(basename $dir)"
    dir=$(dirname $dir)
  fi
  dir="$dir/"

  selected=$(
    ls -d $dir*/ | \
    sed 's|'$dir'||g' | \
    sed 's|/$||g' | \
    sed 's|^\.$||g' | \
    FZF_DEFAULT_OPTS="--reverse $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS --bind 'shift-tab:up,tab:down'" \
    fzf -1 -q "$query" | \
    sed 's/\([ $&!#*()<>|{}[?`"'"'"']\)/\\\1/g'
  )
  if [ "$selected" = "" ]; then
    zle redisplay
    return 0
  fi
  LBUFFER="h $(
    echo $(
      echo $dir | sed 's|'$HOME'/||g'
    )$(
      echo $selected | sed 's/\([ $&!#*()<>|{}[?`"'"'"']\)/\\\1/g'
    )
  )"
  zle redisplay
}

_fn_complete_h() {
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
  local tokens cmd
  tokens=(${(z)LBUFFER})
  cmd=${tokens[1]}
  if [[ "$LBUFFER" =~ "^\ *h$" ]]; then
    zle ${_fn_render_h_selection:-expand-or-complete}
  elif [ "$cmd" = h ]; then
    _fn_render_h_selection ${tokens[2,${#tokens}]/#\~/$HOME}
  else
    zle ${_fn_render_h_selection:-expand-or-complete}
  fi
}

zle -N _fn_complete_h
bindkey '^I' _fn_complete_h
