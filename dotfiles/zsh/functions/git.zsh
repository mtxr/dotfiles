_fn_git_branches_option_list() {
  local IFS=$'\n'
  local grepignore="cat"
  if [ -f "$HOME/.gitbranchignore" ]; then
    grepignore="grep -v \"\$(cat \$HOME/.gitbranchignore)\""
  fi

  local opts=(
    $(printf "%s\t%s\n" Branch Local/Remote)
    $(git branch | \
      rg '(\*? +)\(?(.+)\)?$' --replace '$2' | \
      eval $grepignore | \
      awk '{printf("%s\t%s\n", $1, "Local")}')
    # $([[ "$REMOTE" != "" ]] && git branch -a | \
    #   rg '(\*? +)\(?(.+)\)?$' --replace '$2' | \
    #   rg '^(remotes/)(.+)$' --replace '$2' | \
    #   eval $grepignore | \
    #   awk '{printf("%s\t%s\n", $1, "REMOTE")}')
  )
  printf '%s\n' "${opts[@]}" | column -t -s $'\t'
}

_fzf_complete_git () {
  ARGS="$@"
  if [ -d "$PWD/.git" ]; then
    if [[ "$ARGS" =~ 'git +checkout *$' ]] || \
      [[ "$ARGS" =~ 'git +branch *$' ]] || \
      [[ "$ARGS" =~ 'gco *$' ]] || \
      [[ "$ARGS" =~ "git +(pull|push) +$(git remote | head -n 1) *$" ]] || \
      [[ "$ARGS" =~ "(gps|gpl) +$(git remote | head -n 1) *$" ]];
    then
      _fzf_complete "$FZF_DEFAULT_OPTS --header-lines=1" "$@" < <(
        _fn_git_branches_option_list "$@"
      )
    else
      eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
  else
    eval "zle ${fzf_default_completion:-expand-or-complete}"
  fi
}

_fzf_complete_git_post () {
  cut -f1 -d' '
}

_fzf_complete_gco () {
  _fzf_complete_git "$@"
}

_fzf_complete_gps () {
  _fzf_complete_git "$@"
}

_fzf_complete_gpl () {
  _fzf_complete_git "$@"
}

_fzf_complete_gco_post () {
  _fzf_complete_git_post
}

_fzf_complete_gps_post () {
  _fzf_complete_git_post
}

_fzf_complete_gpl_post () {
  _fzf_complete_git_post
}


