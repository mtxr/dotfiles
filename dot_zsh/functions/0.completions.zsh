if command -v fzf &> /dev/null; then
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

  _fzf_complete () {
    local fifo fzf_opts lbuf fzf matches post
    fifo="${TMPDIR:-/tmp}/fzf-complete-fifo-$$"
    fzf_opts=$1
    lbuf=$2
    post=${POST_FN:-"${funcstack[2]}_post"}
    type $post > /dev/null 2>&1 || post=cat
    fzf="$(__fzfcmd_complete)"
    _fzf_feed_fifo "$fifo"
    matches=$(cat "$fifo" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS" ${=fzf} ${=fzf_opts} -q "${(Q)prefix}" | $post | tr '\n' ' ')
    if [ -n "$matches" ]
    then
    LBUFFER="$lbuf$matches"
    fi
    zle redisplay
    typeset -f zle-line-init > /dev/null && zle zle-line-init
    command rm -f "$fifo"
  }
  # completion key binding
  _fzf-completion-no-trigger-key () {
    local ARGS="$LBUFFER"
    if [[ "$ARGS" =~ "^( |"$'\t'")*$" ]]; then
      POST_FN=_fn_cut_first _fzf_complete "$FZF_DEFAULT_OPTS --header-lines=1" "$@" < <(
        _fn_available_fns | sort
      )
    else
      FZF_COMPLETION_TRIGGER='' fzf-completion
    fi
  }
  zle -N _fzf-completion-no-trigger-key

  bindkey '^P' _fzf-completion-no-trigger-key
  bindkey '^F' _fzf-completion-no-trigger-key
fi
