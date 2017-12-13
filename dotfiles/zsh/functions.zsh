# Join args array into string
join() { local IFS="$1"; shift; echo "$*"; }

# Update workstation
wup() {
  (
    git -C ~/.workstation remote add updates https://github.com/mtxr/dotfiles.git &> /dev/null
    git -C ~/.workstation stash clear &> /dev/null
    git -C ~/.workstation stash &> /dev/null
    git -C ~/.workstation pull --rebase --stat updates "$(git -C ~/.workstation rev-parse --abbrev-ref HEAD)"
    git -C ~/.workstation stash pop > /dev/null
    ~/.workstation/install -q
  )
}

# Save workstation
wsv() {
  local message="$1"
  message=${message:-$(date)}
  (
    git -C ~/.workstation add . && \
    git -C ~/.workstation commit -m "$message" && \
    git -C ~/.workstation push
  )
}

wdf() {
  ( git -C ~/.workstation diff )
}

wst() {
  git -C ~/.workstation status -s
}

# Use pip without requiring virtualenv
syspip() {
  PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

syspip3() {
  PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}

# cd to git root directory
alias cdgr='cd "$(git root)"'

# Create a directory and cd into it
md() {
  mkdir "${1}" && cd "${1}"
}

# Jump to directory containing file
jump() {
  cd "$(dirname ${1})"
}

# builtin cd replacement for screen to track cwd (like tmux)
scr_cd()
{
  cd $1
  screen -X chdir $PWD
}

if [[ -n $STY ]]; then
  alias cd=scr_cd
fi

# Go up [n] directories
up()
{
  local cdir="$(pwd)"
  if [[ "${1}" == "" ]]; then
    cdir="$(dirname "${cdir}")"
  elif ! [[ "${1}" =~ ^[0-9]+$ ]]; then
    echo "Error: argument must be a number"
  elif ! [[ "${1}" -gt "0" ]]; then
    echo "Error: argument must be positive"
  else
    for i in {1..${1}}; do
      local ncdir="$(dirname "${cdir}")"
      if [[ "${cdir}" == "${ncdir}" ]]; then
        break
      else
        cdir="${ncdir}"
      fi
    done
  fi
  cd "${cdir}"
}

# Execute a command in a specific directory
in() {
  ( cd ${1} && shift && ${@} )
}

# Check if a file contains non-ascii characters
nonascii() {
  LC_ALL=C grep -n '[^[:print:][:space:]]' ${1}
}

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

# Serve current directory

serve() {
  pushd ${1:$PWD}; python -m SimpleHTTPServer "${2:-8080}"; popd
}


# git functions
gnb() {
  BRANCH_NAME=$1
  if [ "$#" = 2 ]; then
    ORIGIN_BRANCH=$1
    BRANCH_NAME=$2
    git checkout "$ORIGIN_BRANCH"
  fi
  git checkout -b "$BRANCH_NAME"
}

# ------------------------------------
# Docker alias and function
# ------------------------------------

# Stop all containers
dstop() { docker stop $(docker ps -a -q); }

# Remove all containers
drm() { docker rm $(docker ps -a -q); }

# Remove all images
dri() { docker rmi $(docker images -q); }

# Dockerfile build, e.g., $dbu tcnksm/test
dbu() { docker build -t=$1 .; }

# Show all alias related docker
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

# Bash into running container
dbash() {
  if [ "$1" = "" ];then
    echo "Missing container name." && return 1
  fi
  CONTAINER=$(docker ps -n1 --format "{{.Names}}" -aqf "name=$1")
  echo "Found container: $CONTAINER"
  shift
  docker exec -u ${DUS:-'root'} -i -t $CONTAINER ${DSH:-'bash'} $@
}

alias dsh='DSH=sh dbash'

mkgo () {
  mkdir $@ && cd $@
}
clone-repo() {
  local REPO="$1"
  local FOLDER="$2"

  if [ "$FOLDER" = "" ]; then
    FOLDER="${${REPO##*/}/%.git/}"
  fi
  git clone "$REPO" "$FOLDER" && cd "$FOLDER" && code .
}

wls () {
  local normal=$(tput sgr0)
  local bgwhite="$(tput setab 7)$(tput setaf 0)"
  local COLS=$(tput cols)

  local spaces=$(eval printf %.1s '.{1..'"$(( $COLS - 18 ))"\}; echo)
  echo -e "${bgwhite}Dotfiles Functions${spaces}${normal}"
  rg -e '^(function *)?([A-Za-z0-9][_A-Za-z0-9-]+)( *(\(\))? * \{.*)' --replace '$2' -N --no-filename --no-heading $WORKSTATION/dotfiles/zsh/ | sort | column

  spaces=$(eval printf %.1s '.{1..'"$(( $COLS - 16 ))"\}; echo)
  echo -e "\n${bgwhite}Dotfiles Aliases${spaces}${normal}"
  rg -e 'alias *([A-Z-a-z0-9_-]+)=["$'\''](.+)["$'\''].*' --replace '$1' -N --no-filename --no-heading $WORKSTATION/dotfiles/zsh/ | sort | column
}

## load the rest of functions

for FUNCTION_FILE in $HOME/.zsh/functions/*.zsh
do
  . $FUNCTION_FILE
done
