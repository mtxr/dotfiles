function cd() {
    builtin cd $@
    export LWD=$PWD
    echo $PWD > ~/.lwd
}

# Join args array into string
function join { local IFS="$1"; shift; echo "$*"; }

# Update workstation
function wup() {
    (
        builtin cd ~/.workstation && git -C ~/.workstation pull --ff-only && ~/.workstation/install -q
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
function _rungit-alias() {
    WORKINGDIR=$(pwd)
    PARAMS=("$@")
    PARAMS=("${(@)PARAMS:#$1}")
    COMMAND=$1

    while test $# -gt 0
    do
        case "$1" in
            -C) shift
                WORKINGDIR=$1
                PARAMS=("${(@)PARAMS:#-C}")
                PARAMS=("${(@)PARAMS:#$WORKINGDIR}")
                ;;
        esac
        shift
    done

    git -C $WORKINGDIR $COMMAND $PARAMS
}

function gcm() {
    MESSAGE=""
    if [ $# -eq 1 ];then
        MESSAGE=$1
        shift
    fi

    _rungit-alias add -A
    _rungit-alias commit -m "`date` $MESSAGE" $@
}

function gps() {
    _rungit-alias push --all $@
    _rungit-alias push --tags $@
}

function gdf() {
    _rungit-alias diff $@ | colordiff | less -R
}

function gst() {
    _rungit-alias status $@
}

autoload bashcompinit
bashcompinit

function _complete_go() {
    local cur prev opts max
    local IFS=$'\n'
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}/"
    max=1
    if [ ! -d "$PROJECTS/$prev" ]; then
        prev=""
        max=1
    fi
    opts=$(find $PROJECTS/$prev -maxdepth $max -type d -exec bash -c 'printf "%q\n" "$@"' printf {} ';' | sed 's|'$PROJECTS/$prev'||g' | sed 's/\([ $&!#*()<>|{}[?`"'"'"']\)/\\\1/g' | sed 's#^/\(.*\)$#\1#')

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -o filenames -W "${opts}" -- ${cur}) )
        return 0
    fi
}

function _complete_h() {
    local cur prev opts
    local IFS=$'\n'
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}/"
    if [ ! -d "$HOME/$prev" ]; then
        prev=""
    fi
    opts=$(find $HOME/$prev -maxdepth 1 -type d -exec bash -c 'printf "%q\n" "$@"' printf {} ';' | sed 's|'$HOME/$prev'||g' | sed 's/\([ $&!#*()<>|{}[?`"'"'"']\)/\\\1/g')

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -o filenames -W "${opts}" -- ${cur}) )
        return 0
    fi
}

function go() {
    dir=$(join / $@)
    cd $PROJECTS/$dir
}

function h() {
    dir=$(join / $@)
    cd $HOME/$dir
}

complete -o dirnames -F _complete_go go
complete -o dirnames -F _complete_h h

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
    CONTAINER=$(docker ps -n1 --format "{{.Names}}" -aqf "name=$1")
    echo "Found container: $CONTAINER"
    shift
    docker exec -u ${DUS:-$UID} -i -t $CONTAINER ${DSH:-'bash'} $@
}

alias dsh='DSH=sh dbash'
