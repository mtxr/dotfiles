add-alias () {
  ( mkdir -p ~/.zsh-load &> /dev/null & )
  echo -n "Command: " && \
  command=$(read -e) && \
  echo -n "Aliased to: "  && \
  alias=$(read -e)  && \

  echo "alias $alias='$command'" >> ~/.zsh-load/aliases.sh && \
  . ~/.zsh-load/aliases.sh
}

del-alias () {
  command=$1
  if [ ! -e ~/.zsh-load/aliases.sh ]; then
    echo "There are no aliases." return 0
  fi
  if [ "$command" = "" ];then
    echo -n "Command: " && \
    command=$(read -e)
  fi
  sed -i '' "/alias $command=/d" ~/.zsh-load/aliases.sh
}

local-aliases () {
  if [ ! -e ~/.zsh-load/aliases.sh ]; then
    echo "There are no aliases." return 0
  fi
  cat ~/.zsh-load/aliases.sh
}
