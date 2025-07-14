# Copy SSH public key from agent to a remote machine (like ssh-copy-id)
# Usage: ssh-copy-id-named <user@host> [pattern] [-- <ssh options>]
ssh-copy-id-named() {
  local dest="$1"
  local pattern="$2"
  shift 2
  local ssh_opts=()

  # If '--' is present, treat everything after as ssh options
  if [[ "$1" == "--" ]]; then
    shift
    ssh_opts=("$@")
  fi

  if [ -z "$dest" ] || [ "$dest" = "--help" ] || [ "$dest" = "-h" ]; then
    echo "Usage: ssh-copy-id-named <user@host> [pattern] [-- <ssh options>]"
    echo ""
    echo "Copy a public key from your ssh-agent to a remote host's authorized_keys."
    echo ""
    echo "Arguments:"
    echo "  <user@host>   The remote SSH destination."
    echo "  [pattern]     (Optional) Pattern to match a key in your agent (default: default\$)."
    echo "  [-- <ssh options>] (Optional) Options to pass to ssh (e.g. -p 2222)"
    return 1
  fi

  if ! command -v ssh-add &>/dev/null; then
    echo "ssh-add not found."
    return 1
  fi

  local pubkey
  pubkey=$(ssh-add -L | grep "$pattern\$")
  if [ -z "$pubkey" ]; then
    echo "No matching public key found in agent for pattern: $pattern"
    return 1
  fi

  echo "$pubkey" | ssh "${ssh_opts[@]}" "$dest" 'umask 077; chmod 700 ~/.ssh; mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys &&echo "Key copied!"'
}
