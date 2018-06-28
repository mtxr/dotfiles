gplb() {
  local origin="$1"
  origin=${origin:-"origin"}
  echo ">> git pull $origin `gcb`\n"
  gpl $origin `gcb`
}


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
  )
  printf '%s\n' "${opts[@]}" | column -t -s $'\t'
}

_fn_git_remotes_option_list() {
  local IFS=$'\n'

  local opts=(
    $(printf "%s\n"Remote)
    $(git remote)
  )
  printf '%s\n' "${opts[@]}" | column -t -s $'\t'
}

_fzf_complete_git () {
  local ARGS="$1"
  local opt_fn="$2"
  opt_fn=${opt_fn:-"_fn_git_branches_option_list"}
  if [ -d "$PWD/.git" ]; then
    if [[ "$ARGS" =~ 'git +(pull|push) *$' ]] || \
      [[ "$ARGS" =~ 'gplb *$' ]] || \
      [[ "$ARGS" =~ '(gps|gpl) *$' ]];
    then
      _fzf_complete "$FZF_DEFAULT_OPTS --header-lines=1" "$@" < <(
        _fn_git_remotes_option_list "$@"
      )
    elif [[ "$ARGS" =~ 'git +checkout *$' ]] || \
      [[ "$ARGS" =~ 'git +branch *$' ]] || \
      [[ "$ARGS" =~ 'gco *$' ]] || \
      [[ "$ARGS" =~ '^ *gb *' ]] || \
      [[ "$ARGS" =~ 'git +(pull|push) +[0-9A-Za-z\-]+ *$' ]] || \
      [[ "$ARGS" =~ '(gps|gpl) +[0-9A-Za-z\-]+ *$' ]];
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

_fzf_complete_gb () {
  _fzf_complete_git "$@"
}

_fzf_complete_gps () {
  _fzf_complete_git "$@"
}

_fzf_complete_gpl () {
  _fzf_complete_git "$@"
}

_fzf_complete_gplb () {
  _fzf_complete_git "$@"
}

_fzf_complete_gco_post () {
  _fzf_complete_git_post
}

_fzf_complete_gb_post () {
  _fzf_complete_git_post
}

_fzf_complete_gps_post () {
  _fzf_complete_git_post
}

_fzf_complete_gpl_post () {
  _fzf_complete_git_post
}

fzf_complete_gplb_post () {
  _fzf_complete_git_post
}
