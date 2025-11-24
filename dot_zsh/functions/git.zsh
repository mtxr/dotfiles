# cd to git root directory
alias cdgr='cd "$(git root)"'

# Fetch pull request
fpr() {
  if [ "$#" -eq 2 ]; then
    local repo="${PWD##*/}"
    local user="${1}"
    local branch="${2}"
  elif [ "$#" -eq 3 ]; then
    local repo="${1}"
    local user="${2}"
    local branch="${3}"
  else
    echo "Usage: fpr [repo] username branch"
    return 1
  fi

  git fetch "git@github.com:${user}/${repo}" "${branch}:${user}/${branch}"
}

clone-repo() {
  local REPO="$1"
  local FOLDER="$2"

  if [ "$FOLDER" = "" ]; then
    FOLDER="${${REPO##*/}/%.git/}"
  fi
  git clone "$REPO" "$FOLDER" && cd "$FOLDER" && $EDITOR .
}

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
  if [ $(gst --porcelain | count) -eq 0 ]; then
    return 0
  fi
  if [ $(gst --porcelain | rg '^\w' | count) -eq 0 ]; then
    gst
    echo ""
    local confirmation=$(bash -c 'read -n 1 -p "Stage all files? (y/N): " confirmation && echo $confirmation')
    echo ""
    if [[ "$confirmation" =~ '[yY]' ]];then
      git add -A
    else
      if command -v sk &> /dev/null; then
        git add $(git ls-files -m -o --exclude-standard | sk -m --header "Let's select the files you want to stage")
      else
        echo "you need to add files manually"
        return 1
      fi
    fi
  fi

  if [[ "$@" =~ "^-" ]]; then
    git commit $@
  elif [[ "$@" == "" ]]; then
    git commit
  else
    local message="$1"
    shift 1

    git commit -m "$message" $@
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
    $(printf "%s\t%s\t%s\n" "C/B" "")
    $(git branch | \
      rg '(\*? +)\(?(.+)\)?$' --replace '$2' | \
      eval $grepignore | \
      awk '{printf("%s\t%s\n", $1, "Local")}')
    $(git log --pretty='%h'$'\t''%d %s' -n 50)
  )
  printf '%s\n' "${opts[@]}" | column -t -s $'\t'
}

_fn_git_commit_option_list() {
  local IFS=$'\n'
  local opts=(
    $(printf "%s\t%s\t%s\t%s\n" "#" "Commit" "Message")
    $(git log --pretty='%h'$'\t''%d %s' | cat -n)
  )
  printf '%s\n' "${opts[@]}" | column -t -s $'\t'
}

_skim_complete_git () {
  local ARGS="$1"
  local opt_fn="$2"
  opt_fn=${opt_fn:-"_fn_git_branches_option_list"}
  if [ -d "$PWD/.git" ]; then
    if [[ "$ARGS" =~ 'git +(pull|push) *$' ]] || \
      [[ "$ARGS" =~ 'gplb *$' ]] || \
      [[ "$ARGS" =~ '(gps|gpl) *$' ]];
    then
      _skim_generic_complete "$SKIM_DEFAULT_OPTIONS --header-lines=1" "$@" < <(
        _fn_git_remotes_option_list "$@"
      )
    elif [[ "$ARGS" =~ 'git +checkout *$' ]] || \
      [[ "$ARGS" =~ 'git +diff *$' ]] || \
      [[ "$ARGS" =~ 'gdf *$' ]] || \
      [[ "$ARGS" =~ 'gco *$' ]];
    then
      _skim_generic_complete "$SKIM_DEFAULT_OPTIONS --header-lines=1" "$@" < <(
        _fn_git_branches_and_commits_option_list "$@"
      )
    elif [[ "$ARGS" =~ 'git +branch *$' ]] || \
      [[ "$ARGS" =~ 'git +merge *$' ]] || \
      [[ "$ARGS" =~ 'gb *' ]] || \
      [[ "$ARGS" =~ 'git +(pull|push) +[0-9A-Za-z\-]+ *$' ]] || \
      [[ "$ARGS" =~ '(gps|gpl) +[0-9A-Za-z\-]+ *$' ]];
    then
      _skim_generic_complete "$SKIM_DEFAULT_OPTIONS --header-lines=1" "$@" < <(
        _fn_git_branches_option_list "$@"
      )
    else
      eval "zle ${skim_default_completion:-expand-or-complete}"
    fi
  else
    eval "zle ${skim_default_completion:-expand-or-complete}"
  fi
}

_skim_complete_git_post () {
  cut -f1 -d' '
}

_skim_complete_git_commit_post() {
  rg ' *\d+ *([a-f0-9]{8})' -o --replace '$1' --color never
}

_skim_complete_gco () {
  _skim_complete_git "$@"
}

_skim_complete_gb () {
  _skim_complete_git "$@"
}

_skim_complete_gps () {
  _skim_complete_git "$@"
}

_skim_complete_gpl () {
  _skim_complete_git "$@"
}

_skim_complete_gplb () {
  _skim_complete_git "$@"
}

_skim_complete_gdf () {
  _skim_complete_git "$@"
}

_skim_complete_gco_post () {
  _skim_complete_git_post
}

_skim_complete_gb_post () {
  _skim_complete_git_post
}

_skim_complete_gps_post () {
  _skim_complete_git_post
}

_skim_complete_gpl_post () {
  _skim_complete_git_post
}

_skim_complete_gplb_post () {
  _skim_complete_git_post
}

_skim_complete_gdf_post () {
  _skim_complete_git_post
}
