#!/bin/bash

# read args
for i in "$@"
do
case $i in
    --pane-current-path=*)
    PANE_CURRENT_PATH="${i#*=}"
    shift # past argument=value
    ;;
    --pane-active=*)
    PANE_ACTIVE="${i#*=}"
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
PRETTY_PATH=$(sed "s:^$HOME:~:" <<< $PANE_CURRENT_PATH  | rg -e '(\w)[^/]*/' --replace '$1/')

COMMAND_PART=""
if [ "$PANE_COMMAND" != "" ];then
  COMMAND_PART=" => ($PANE_COMMAND)"
fi

GIT_PART="$(gitmux -q -fmt tmux $PANE_CURRENT_PATH)"
if [ "$GIT_PART" != "" ];then
  GIT_PART=" $GIT_PART"
fi

# final output
echo " #[bold,fg=yellow]$PRETTY_PATH$GIT_PART "