#!/bin/sh

set -e

apk --update add bash zsh bind-tools git curl busybox-extras neovim tmux mosh

if ! grep -qF "Host me" /etc/ssh/ssh_config; then
  cat << EOF | sudo tee -a /etc/ssh/ssh_config
Host me
Hostname tuannvm.com
Port 2220
User me
EOF
fi
