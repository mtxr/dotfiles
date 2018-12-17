# Auto update - whi will try to autoupdate configs
if [ "$DOTFILES_AUTOUPDATE" = "true" ]; then
  local WORKSTATION_LOCKFILE='/var/lock/wup.lock'
  local WORKSTATION_LOGFILE='/tmp/wup.log'

  if [ ! -f "$DOTFILES_LOCKFILE" ] && (
    [ ! -f "$DOTFILES_LOGFILE" ] ||
    [ "$(( (`date +%s` - `date -r $DOTFILES_LOGFILE +%s`) / 86400 ))" -gt 1 ]
  ); then
    (
      (
        touch $DOTFILES_LOCKFILE && \
        echo "$(date)\nStarting" && \
        wup
        rm $DOTFILES_LOCKFILE
      ) >> $DOTFILES_LOGFILE 2>&1 &
    )
  fi
fi
