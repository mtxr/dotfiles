# Use colors in coreutils utilities output
alias ls='ls --color=auto'
alias grep='grep --color'

# ls aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls'
alias k='k -ha' # zsh plugin K for git repositories

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

# Mirror a website
alias mirrorsite='wget -m -k -K -E -e robots=off'

# Mirror stdout to stderr, useful for seeing data going through a pipe
alias peek='tee >(cat 1>&2)'

# Git Aliases
alias gcb='git rev-parse --abbrev-ref HEAD' # current branch

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