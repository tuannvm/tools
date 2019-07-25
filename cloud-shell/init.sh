#!/bin/bash

set -e

mkdir -p ~/.cloudshell
touch ~/.cloudshell/no-apt-get-warning

sudo apt-get update
sudo apt-get install telnet git curl iputils-ping dnsutils traceroute net-tools iproute2 iperf3 postgresql-client netcat mosh -y

if ! grep -qF "Host me" /etc/ssh/ssh_config; then
  cat << EOF | sudo tee -a /etc/ssh/ssh_config
  Host me
  Hostname tuannvm.com
  Port 2220
  User me
EOF
fi
