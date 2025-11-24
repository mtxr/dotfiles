if command -v sk &> /dev/null; then
  _fn_available_fns () {
    local IFS=$'\n'
    local opts=(
      $(printf "%s\t%s\n" Name Type)
      $(alias | rg '^(\w+)=(.+)$' --replace "\$1"$'\t'"Alias \$2")
      $(compgen -b | rg '^[A-Za-z]' --color=never | awk '{printf("%s\t%s\n", $1, "Builtin Function")}')
      $(compgen -k | rg '^[A-Za-z]' --color=never | awk '{printf("%s\t%s\n", $1, "Keyword")}')
      $(compgen -A function | rg '^[A-Za-z]' | awk '{printf("%s\t%s\n", $1, "Function")}')
    )
    printf '%s\n' "${opts[@]}" | column -t  -s $'\t'
  }

  _fn_cut_first() {
    cut -d' ' -f1
  }

  _skim_feed_fifo() {
    command rm -f "$1"
    mkfifo "$1"
    cat <&0 > "$1" &|
  }

  _skim_generic_complete () {
    local fifo skim_opts lbuf skim_cmd matches post
    fifo="${TMPDIR:-/tmp}/skim-complete-fifo-$$"
    skim_opts=$1
    lbuf=$2
    post=${POST_FN:-"${funcstack[2]}_post"}
    type $post > /dev/null 2>&1 || post=cat
    skim_cmd="sk"
    _skim_feed_fifo "$fifo"
    matches=$(cat "$fifo" | SKIM_DEFAULT_OPTIONS="--height ${SKIM_TMUX_HEIGHT:-40%} $SKIM_DEFAULT_OPTIONS $SKIM_COMPLETION_OPTIONS" ${=skim_cmd} ${=skim_opts} -q "${(Q)prefix}" | $post | tr '\n' ' ')
    if [ -n "$matches" ]
    then
    LBUFFER="$lbuf$matches"
    fi
    zle redisplay
    typeset -f zle-line-init > /dev/null && zle zle-line-init
    command rm -f "$fifo"
  }
  # completion key binding
  _skim-completion-no-trigger-key () {
    local ARGS="$LBUFFER"
    if [[ "$ARGS" =~ "^( |"$'\t'")*$" ]]; then
      POST_FN=_fn_cut_first _skim_generic_complete "$SKIM_DEFAULT_OPTIONS --header-lines=1" "$@" < <(
        _fn_available_fns | sort
      )
    else
      SKIM_COMPLETION_TRIGGER='' skim-completion
    fi
  }
  zle -N _skim-completion-no-trigger-key

  bindkey '^P' _skim-completion-no-trigger-key
  bindkey '^F' _skim-completion-no-trigger-key
fi
