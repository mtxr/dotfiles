gignore() {
  if [ ! -d .git ]; then
    echo "Not in a git repository" &> /dev/stderr
    return 1
  fi
  if [ "$1" = "" ]; then
    cat .gitignore && return 0
  fi
  local description="$2"

  if [ "$description" != "" ];then
    echo "\n# $description\n$1" >> .gitignore && {echo "..." && tail .gitignore}
    return 0
  fi

  echo "$1" >> .gitignore && {echo "..." && tail .gitignore}
  return 0
}

gcm() {
  if [ $# -gt 0 ];then
    git add -A && git commit -m $@
  else
    git add -A && git commit $@
  fi
}

gplb() {
  local origin=${1:-"origin"}
  echo ">> git pull $origin `gcb`\n"
  gpl $origin `gcb`
}


gf-pr () {
  local PR="$1"
  local origin=${2:-"origin"}
  git fetch $origin pull/$PR/head:PR-$PR && gco PR-$PR
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

_fn_git_branches_and_commits_option_list() {
  local IFS=$'\n'
  local grepignore="cat"
  if [ -f "$HOME/.gitbranchignore" ]; then
    grepignore="grep -v \"\$(cat \$HOME/.gitbranchignore)\""
  fi

  local opts=(
    $(printf "%s\t%s\t%s\n" "C/B" "Head" "Message")
    $(git branch | \
      rg '(\*? +)\(?(.+)\)?$' --replace '$2' | \
      eval $grepignore | \
      awk '{printf("%s\t%s\n", $1, "Local")}')
    $(git log --pretty='%h'$'\t''%d'$'\t''%s')
  )
  printf '%s\n' "${opts[@]}" | column -t -s $'\t'
}

_fn_git_commit_option_list() {
  local IFS=$'\n'
  local opts=(
    $(printf "%s\t%s\t%s\t%s\n" "#" "Commit" "Head" "Message")
    $(git log --pretty='%h'$'\t''%d'$'\t''%s' | cat -n)
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
      [[ "$ARGS" =~ 'git +diff *$' ]] || \
      [[ "$ARGS" =~ 'gdf *$' ]] || \
      [[ "$ARGS" =~ 'gco *$' ]];
    then
      _fzf_complete "$FZF_DEFAULT_OPTS --header-lines=1" "$@" < <(
        _fn_git_branches_and_commits_option_list "$@"
      )
    elif [[ "$ARGS" =~ 'git +branch *$' ]] || \
      [[ "$ARGS" =~ 'git +merge *$' ]] || \
      [[ "$ARGS" =~ 'gb *' ]] || \
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

_fzf_complete_git_commit_post() {
  rg ' *\d+ *([a-f0-9]{8})' -o --replace '$1' --color never
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

_fzf_complete_gdf () {
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

fzf_complete_gdf_post () {
  _fzf_complete_git_post
}
