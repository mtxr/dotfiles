_fn_docker_commands_option_list() {
  { echo Command$'\t'Description ; (docker 2>&1 | rg '^  ([a-z]+) +(.+)$' --replace "\$1"$'\t'"\$2" --color=never) } | column -t -s $'\t'
}

_fn_docker_container_option_list() {
  docker ps --format "table  {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}" -a
}

_skim_complete_docker() {
  ARGS="$@"
  if [[ "$ARGS" =~ '^ *docker +(start|restart|stop) *$' ]];then
    _skim_generic_complete "$SKIM_DEFAULT_OPTIONS --header-lines=1" "$@" < <(
      _fn_docker_container_option_list
    )
  elif [[ "$ARGS" =~ '^ *docker *$' ]];then
    _skim_generic_complete "$SKIM_DEFAULT_OPTIONS --header-lines=1" "$@" < <(
      _fn_docker_commands_option_list
    )
  else
    eval "zle ${skim_default_completion:-expand-or-complete}"
  fi
}

_skim_complete_docker_post() {
  cut -f1 -d' '
}

alias dc='docker-compose'