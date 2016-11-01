# Use colors in coreutils utilities output
alias ls='ls --color=auto'
alias grep='grep --color'

# ls aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'

# git related aliases
alias gag='git exec ag'

unalias rm  &>/dev/null
unalias cp  &>/dev/null
unalias mv  &>/dev/null
unalias grc  &>/dev/null

alias diff='colordiff'
alias fuck='sudo $(fc -ln -1)'
alias grep='grep --color=always'
alias mtr='grc mtr'
alias netstat='grc netstat'
alias ping='grc ping'
alias pj='cd $PROJECTS'
alias ps='grc ps aux'
alias pserver='python -m SimpleHTTPServer'
alias reloadzsh='source ~/.zshrc'
alias rm='nocorrect rm'
alias tail='grc tail'
alias traceroute='grc traceroute'
alias updsys='sudo apt-get update'
alias upgsys='sudo apt-get upgrade'
alias upsys='updsys && upgsys'
alias xcp='xclip -sel clip'
alias yolo=fuck
alias zshconfig='vim ~/.zshrc'

# Update workstation
function wu() {
    (
        cd ~/.workstation && git pull --ff-only && ./install -q
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
function mcd() {
    mkdir "${1}" && cd "${1}"
}

# Jump to directory containing file
function jump() {
    cd "$(dirname ${1})"
}

# cd replacement for screen to track cwd (like tmux)
function scr_cd()
{
    builtin cd $1
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

# Mirror a website
alias mirrorsite='wget -m -k -K -E -e robots=off'

# Mirror stdout to stderr, useful for seeing data going through a pipe
alias peek='tee >(cat 1>&2)'
