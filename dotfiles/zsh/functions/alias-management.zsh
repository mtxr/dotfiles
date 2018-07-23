add-alias () {
  ( mkdir -p $HOME/.zsh-load &> /dev/null & )
  echo -n "Command: " && \
  command=$(read -e) && \
  echo -n "Aliased to: "  && \
  alias=$(read -e)  && \

  echo "alias $alias='$command'" >> $HOME/.zsh-load/aliases.sh && \
  . $HOME/.zsh-load/aliases.sh
}

del-alias () {
  command=$1
  if [ ! -e $HOME/.zsh-load/aliases.sh ]; then
    echo "There are no aliases." && return 0
  fi
  if [ "$command" = "" ];then
    echo -n "Command: " && \
    command=$(read -e)
  fi
  sed -i '' "/alias $command=/d" $HOME/.zsh-load/aliases.sh
}

local-aliases () {
  if [ ! -e $HOME/.zsh-load/aliases.sh ]; then
    echo "There are no aliases." && return 0
  fi
  cat $HOME/.zsh-load/aliases.sh
}
