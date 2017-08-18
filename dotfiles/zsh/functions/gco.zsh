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

_fzf_complete_gco() {
  _fzf_complete "$FZF_DEFAULT_OPTS --header-lines=1" "$@" < <(
    _fn_gco_option_list
  )
}

_fzf_complete_gco_post() {
  cut -f1 -d' '
}
