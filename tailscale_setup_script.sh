#!/usr/bin/env bash
# tailscale_join.sh (with embedded auth key)
#
# Edit the following variable to your Tailscale auth key before running:
TAILSCALE_AUTHKEY="tskey-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Optional: specify a custom hostname here. By default, the system hostname will be used.
#HOSTNAME="my-custom-hostname"

# Usage:
#   sudo ./tailscale_join.sh

set -euo pipefail

# Validate the embedded auth key
if [[ -z "$TAILSCALE_AUTHKEY" ]]; then
  echo "ERROR: TAILSCALE_AUTHKEY is empty. Please edit the script and set your key." >&2
  exit 1
fi

# Determine hostname
if [[ -n "${HOSTNAME:-}" ]]; then
  HOST="$HOSTNAME"
else
  HOST=$(hostname)
fi

# Install Tailscale using the official installer
echo "Installing Tailscale via https://tailscale.com/install.sh..."
curl -fsSL https://tailscale.com/install.sh | sh

# Enable and start the service
echo "Enabling and starting tailscaled..."
systemctl enable --now tailscaled

# Join Tailnet
echo "Joining Tailnet as '$HOST'..."
tailscale up --authkey "$TAILSCALE_AUTHKEY" --hostname "$HOST" --accept-routes

echo "Done! Run 'tailscale status' to verify connectivity."
