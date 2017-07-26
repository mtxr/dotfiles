_fn_gco_option_list() {
  local IFS=$'\n'
  local grepignore="cat"
  if [ -f "$HOME/.gitbranchignore" ]; then
    grepignore="grep -v \"\$(cat \$HOME/.gitbranchignore)\""
  fi

  local opts=(
    $(printf "%s\t%s\n" HEAD LOCAL)
    $(git branch | \
      rg '(\*? +)\(?(.+)\)?$' --replace '$2' | \
      eval $grepignore | \
      awk '{printf("%s\t%s\n", $1, "LOCAL")}')
    # $(git branch -a | \
    #   rg '(\*? +)\(?(.+)\)?$' --replace '$2' | \
    #   rg '^(remotes/)(.+)$' --replace '$2' | \
    #   eval $grepignore | \
    #   awk '{printf("%s\t%s\n", $1, "REMOTE")}')
  )
  printf '%s\n' "${opts[@]}" | column -t
}

_fn_gco_completion() {
  local cmd="$1"
  shift
  local query="$@"
  local selected

  selected=$(
    FZF_DEFAULT_OPTS="--reverse --cycle $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS --bind 'shift-tab:up,tab:down'" \
    fzf -1 -q "$query" < <( _fn_gco_option_list )
  )
  if [ "$selected" = "" ]; then
    zle redisplay
    return 0
  fi

  LBUFFER="$cmd $(echo $selected | cut -f1 -d' ')"
  zle redisplay
}

_fn_gco_complete() {
  git rev-parse --git-dir &> /dev/null || return 1
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
  local tokens cmd subcmd
  tokens=(${(z)LBUFFER})
  cmd=${tokens[1]}
  subcmd=${tokens[2]}

  if [[ "$LBUFFER" =~ "^\ *gco$" ]] || [[ "$LBUFFER" =~ "^\ *git checkout$" ]]; then
    zle ${_fn_gco_default_completion:-expand-or-complete}
  elif [ "$cmd" = gco ]; then
    _fn_gco_completion "gco" ${tokens[2,${#tokens}]}
  elif [[ "$cmd $subcmd" =~ "git *checkout" ]]; then
    _fn_gco_completion "git checkout" ${tokens[3,${#tokens}]}
  else
    zle ${_fn_gco_default_completion:-expand-or-complete}
  fi
}

[ -z "$_fn_gco_default_completion" ] && {
  binding=$(bindkey '^I')
  [[ $binding =~ 'undefined-key' ]] || _fn_gco_default_completion=$binding[(s: :w)2]
  unset binding
}

zle -N _fn_gco_complete
bindkey '^I' _fn_gco_complete
