_fn_docker_option_list() {
  docker ps --format "table  {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}" -a
}

_fzf_complete_docker() {
  _fzf_complete "$FZF_DEFAULT_OPTS --header-lines=1" "$@" < <(
    _fn_docker_option_list
  )
  # zle accept-line
}

_fzf_complete_docker_post() {
  cut -f1 -d' '
}
