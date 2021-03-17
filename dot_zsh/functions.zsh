# Join args array into string
join() { local IFS="$1"; shift; echo "$*"; }

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
    tmux attach -t $name || tmux -CC new -s $name
    return 0
  fi

  tmux attach -t $name || tmux -CC new -s $name -c "$2"
}

if [ ! "$(command -v realpath)" ]; then
  realpath() {
    python -c "import os; print(os.path.realpath('$1'))"
  }
fi