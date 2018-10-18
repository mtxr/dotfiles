#!/bin/zsh

exec xautolock -detectsleep \
  -time 3 -locker "slock" \
  -notify 30 \
  -notifier "notify-send -u critical -t 10000 -- 'LOCKING screen in 30 seconds'"
