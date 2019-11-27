#!/bin/bash
HOME_ICON=$'\uf015'
# read args
for i in "$@"
do
case $i in
    --pane-current-path=*)
    PANE_CURRENT_PATH="${i#*=}"
    shift # past argument=value
    ;;
    --pane-current-command=*)
    PANE_COMMAND="${i#*=}"
    shift # past argument=value
    ;;
    *) # unknown option
    ;;
esac
done

# replace full path to home directory with ~
if [ $PANE_CURRENT_PATH = $HOME ];then
  PRETTY_PATH=$HOME_ICON
else
  PRETTY_PATH=$(echo $PANE_CURRENT_PATH | rg "$HOME" --replace "$HOME_ICON" | rg -e '([^/])[^/]*/' --replace '$1/')
fi

COMMAND_PART=" => ($PANE_COMMAND)"

GIT_PART="$(gitmux -q -fmt tmux $PANE_CURRENT_PATH)"
if [[ "$GIT_PART" =~ " *" ]];then
  GIT_PART=" $GIT_PART  "
fi

# final output
echo "#[bold,fg=magenta][ #[bold,fg=yellow]$PRETTY_PATH $GIT_PART#[bold,fg=magenta] ]$COMMAND_PART "