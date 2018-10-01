unalias rf  &>/dev/null
unalias rm  &>/dev/null
unalias cp  &>/dev/null
unalias mv  &>/dev/null
unalias grc &>/dev/null

alias count="wc -l"

# using github/hub as git
alias git='hub'

# Use colors in coreutils utilities output
alias ls='ls -G --color=auto'
alias grep='grep --color'
alias ccat='pygmentize -g'

# ls aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls'
alias k='k -ha' # zsh plugin K for git repositories

# Aliases to protect against overwriting
alias rm='rm --interactive=once -I'

# git related aliases
alias gag='git exec ag'

alias diff='colordiff'
alias fuck='sudo $(fc -ln -1)'
alias grep='grep --color=always'
alias mtr='grc mtr'
alias netstat='grc netstat'
alias ping='grc ping'
alias ps='grc ps aux'
alias pyserver='python -m SimpleHTTPServer'
alias phpserver='php -S 0.0.0.0:8000'
alias rzsh='source ~/.zshrc'
alias tail='grc tail'
alias traceroute='grc traceroute'
alias updsys='(type apt-get &> /dev/null && sudo apt-get update) || (type brew &> /dev/null && dnf check-update)'
alias upgsys='(type apt-get &> /dev/null && sudo apt-get upgrade) || (type brew &> /dev/null && dnf upgrade)'
alias upsys='updsys && upgsys'
alias xcp='xclip -sel clip'
alias yolo=fuck
alias zshconfig='vim ~/.zshrc'
alias chownme='chown -R $(id -u):$(id -g)'

# Mirror a website
alias mirrorsite='wget -m -k -K -E -e robots=off'

# Mirror stdout to stderr, useful for seeing data going through a pipe
alias peek='tee >(cat 1>&2)'

# Git Aliases
alias gb='git branch'
alias gcb='git rev-parse --abbrev-ref HEAD' # current branch
alias gco='git checkout'
alias gcof='gco $(git rev-list --all | rg $(git rev-parse HEAD) -B1 | head -n 1)'
alias gcop='gco $(git rev-list --all | rg $(git rev-parse HEAD) -A1 | tail -n 1)'
alias gch='gco HEAD'
alias gst='git status -s'
alias gdf='git diff'
alias gpl='git pull'
alias gps='git push'
alias gmine='git log --author="$(git config --get user.name)" --grep="^[a-zA-Z0-9]{7} ((?![mM]erge).*)$" --perl-regexp'
alias gbcls='git branch --merged | egrep -v "(^\*|${GIT_CLEAR_BRANCH_EXCLUDE})" | xargs git branch -d'

# ------------------------------------
# Docker alias
# ------------------------------------

# Get latest container ID
alias dl="docker ps -l -q"

# Get container process
alias dps="docker ps"

# Get process included stop container
alias dpa="docker ps -a"

# Get images
alias di="docker images"

# Get container IP
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"

# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"

# Execute interactive container, e.g., $dex base /bin/bash
alias dex="docker exec -i -t"

alias dls='docker ps --format "table  {{.Names}}\t{{.Status}}\t{{.Ports}}"'

alias rlink='python -c "import os,sys;print(os.path.realpath(sys.argv[1]))"'

alias wrl='source $HOME/.zshrc'
alias wscd='cd $HOME/.workstation'


# utilities
alias todos="rg -e '(//|#|<!--|;)\s*(TODO|FIXME)'"
