# Join args array into string
join() { local IFS="$1"; shift; echo "$*"; }

# Update workstation
wup() {
  (
    git -C $DOTFILES remote add updates https://github.com/mtxr/dotfiles.git &> /dev/null
    git -C $DOTFILES stash clear &> /dev/null
    git -C $DOTFILES stash &> /dev/null
    git -C $DOTFILES pull --rebase --stat updates "$(git -C $DOTFILES rev-parse --abbrev-ref HEAD)"
    git -C $DOTFILES stash pop > /dev/null
    $DOTFILES/install "$DOTFILES"
  )
}

# Save workstation
wsv() {
  local message="$1"
  message=${message:-$(date)}
  (
    git -C $DOTFILES push && \
    git -C $DOTFILES add . && \
    git -C $DOTFILES commit -m "$message" && \
    git -C $DOTFILES push
  )
}

wdf() {
  ( git -C $DOTFILES diff )
}

wst() {
  git -C $DOTFILES status -s
}

# Use pip without requiring virtualenv
syspip() {
  PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

syspip3() {
  PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}

# Create a directory and cd into it
md() {
  mkdir "${1}" && cd "${1}"
}

# Jump to directory containing file
jump() {
  cd "$(dirname ${1})"
}

# Execute a command in a specific directory
in() {
  ( cd ${1} && shift && ${@} )
}

# Check if a file contains non-ascii characters
nonascii() {
  LC_ALL=C grep -n '[^[:print:][:space:]]' ${1}
}

# Serve current directory

serve() {
  pushd ${1:$PWD}; python -m SimpleHTTPServer "${2:-8080}"; popd
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

wls () {
  local normal=$(tput sgr0)
  local bgwhite="$(tput setab 7)$(tput setaf 0)"
  local COLS=$(tput cols)

  local spaces=$(eval printf %.1s '.{1..'"$(( $COLS - 18 ))"\}; echo)
  echo -e "${bgwhite}rcfiles Functions${spaces}${normal}"
  rg -e '^(function *)?([A-Za-z0-9][_A-Za-z0-9-]+)( *(\(\))? * \{.*)' --replace '$2' -N --no-filename --no-heading $DOTFILES/rcfiles/zsh/ | sort | column

  spaces=$(eval printf %.1s '.{1..'"$(( $COLS - 16 ))"\}; echo)
  echo -e "\n${bgwhite}rcfiles Aliases${spaces}${normal}"
  rg -e 'alias *([A-Z-a-z0-9_-]+)=["$'\''](.+)["$'\''].*' --replace '$1' -N --no-filename --no-heading $DOTFILES/rcfiles/zsh/ | sort | column
}

## load the rest of functions

for FUNCTION_FILE in $HOME/.zsh/functions/*.zsh
do
  . $FUNCTION_FILE
done

del-hist () {
  if [ "$1" = "" ]; then
    sed -i '/del-hist/d' $HISTFILE
    return 0
  fi
  sed -i '/'$1'/d' $HISTFILE
  sed -i '/del-hist/d' $HISTFILE
}

function grabc() { awk "{print \$${1:-1}}"; }


tns() {
  local name="$1"
  local dir="$2"

  if [ "$name" = "" ];then
    tmux new
    return 0
  fi

  if [ "$dir" = "" ];then
    tmux attach -t $name || tmux new -s $name
    return 0
  fi

  tmux attach -t $name || tmux new -s $name -c "$2"
}