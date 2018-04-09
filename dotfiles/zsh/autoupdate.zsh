echo "AAAAAAAAAAAAa"
# Auto update - whi will try to autoupdate configs
if [ "$WORKSTATION_AUTOUPDATE" = "true" ]; then
  echo "A"
  local WORKSTATION_LOCKFILE='/var/lock/wup.lock'
  local WORKSTATION_LOGFILE='/tmp/wup.log'
  echo "AA $WORKSTATION_LOCKFILE $WORKSTATION_LOGFILE"
  [ ! -f "$WORKSTATION_LOGFILE" ] && touch $WORKSTATION_LOGFILE

  if [ ! -f "WORKSTATION_LOCKFILE" ] || [ "$(( (`date +%s` - `date -r $WORKSTATION_LOGFILE +%s`) / 86400 ))" -gt 1 ]; then
    echo "B"
    (
      touch $WORKSTATION_LOCKFILE && \
      echo "$(date)\nStarting" && \
      wup
      rm $WORKSTATION_LOCKFILE
    ) >> $WORKSTATION_LOGFILE 2>&1 &
    echo "C"
  fi
fi
