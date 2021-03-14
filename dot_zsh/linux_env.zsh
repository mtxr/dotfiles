if type gnome-keyring-daemon &> /dev/null; then
  dbus-update-activation-environment --systemd DISPLAY
  eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg 2> /dev/null)
  export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
fi
