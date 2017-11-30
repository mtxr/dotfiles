# Join args array into string
function join { local IFS="$1"; shift; echo "$*"; }

# Update workstation
function wup() {
    (
        git -C ~/.workstation remote add updates https://github.com/mtxr/dotfiles.git &> /dev/null
        git -C ~/.workstation stash &> /dev/null
        git -C ~/.workstation pull --rebase --stat updates "$(git -C ~/.workstation rev-parse --abbrev-ref HEAD)"
        git -C ~/.workstation stash apply > /dev/null
        ~/.workstation/install -q
    )
}

# Save workstation
function wsv() {
    (
        git -C ~/.workstation add . && git -C ~/.workstation commit -m "`date`" && git -C ~/.workstation push
    )
}

function wdf() {
    (
        git -C ~/.workstation diff
    )
}

function wst() {
    (
        git -C ~/.workstation status
    )
}

# Use pip without requiring virtualenv
function syspip() {
    PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

function syspip3() {
    PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}

# cd to git root directory
alias cdgr='cd "$(git root)"'

# Create a directory and cd into it
function md() {
    mkdir "${1}" && cd "${1}"
}

# Jump to directory containing file
function jump() {
    cd "$(dirname ${1})"
}

# builtin cd replacement for screen to track cwd (like tmux)
function scr_cd()
{
    cd $1
    screen -X chdir $PWD
}

if [[ -n $STY ]]; then
    alias cd=scr_cd
fi

# Go up [n] directories
function up()
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
function in() {
    (
        cd ${1} && shift && ${@}
    )
}

# Check if a file contains non-ascii characters
function nonascii() {
    LC_ALL=C grep -n '[^[:print:][:space:]]' ${1}
}

# Fetch pull request

function fpr() {
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

function serve() {
    pushd ${1:$PWD}; python -m SimpleHTTPServer "${2:-8080}"; popd
}


# git functions
function gnb() {
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
function dstop() { docker stop $(docker ps -a -q); }

# Remove all containers
function drm() { docker rm $(docker ps -a -q); }

# Remove all images
function dri() { docker rmi $(docker images -q); }

# Dockerfile build, e.g., $dbu tcnksm/test
function dbu() { docker build -t=$1 .; }

# Show all alias related docker
function dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

# Bash into running container
function dbash() {
    if [ "$1" = "" ];then
        echo "Missing container name." && return 1
    fi
    CONTAINER=$(docker ps -n1 --format "{{.Names}}" -aqf "name=$1")
    echo "Found container: $CONTAINER"
    shift
    docker exec -u ${DUS:-'root'} -i -t $CONTAINER ${DSH:-'bash'} $@
}

alias dsh='DSH=sh dbash'

for FUNCTION_FILE in $HOME/.zsh/functions/*.zsh
do
  . $FUNCTION_FILE
done
