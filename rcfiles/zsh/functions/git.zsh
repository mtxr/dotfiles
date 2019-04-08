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
  git clone "$REPO" "$FOLDER" && cd "$FOLDER" && code .
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
      echo "Let's select the fiiles you want to stage: "
      git add -i
    fi
  fi

  if [[ "$@" =~ "^-" ]]; then
    git commit $@
  elif [[ "$@" == "" ]]; then
    git commit
  else
    local message="$1"
    shift 1

    if [[ ! "$message" =~ "^$(gcb)" ]];then
      local confirmation=$(bash -c 'read -n 1 -p "Prefix with branch name? (Y/n): " confirmation && echo $confirmation')
      if [[ "$confirmation" =~ '[yY]' ]] || [ "$confirmation" = '' ];then
        message="$(gcb): $message"
      fi
    fi
    echo ""
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
