# Auto update - whi will try to autoupdate configs
if [ "$WORKSTATION_AUTOUPDATE" = "true" ]; then
  local WORKSTATION_LOCKFILE='/var/lock/wup.lock'
  local WORKSTATION_LOGFILE='/tmp/wup.log'

  if [ ! -f "$WORKSTATION_LOCKFILE" ] && (
    [ ! -f "$WORKSTATION_LOGFILE" ] ||
    [ "$(( (`date +%s` - `date -r $WORKSTATION_LOGFILE +%s`) / 86400 ))" -gt 1 ]
  ); then
    (
      (
        touch $WORKSTATION_LOCKFILE && \
        echo "$(date)\nStarting" && \
        wup
        rm $WORKSTATION_LOCKFILE
      ) >> $WORKSTATION_LOGFILE 2>&1 &
    )
  fi
fi
