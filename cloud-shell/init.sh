#!/bin/bash

set -e

mkdir -p ~/.cloudshell
touch ~/.cloudshell/no-apt-get-warning

sudo apt-get update
sudo apt-get install telnet git curl iputils-ping dnsutils traceroute net-tools iproute2 iperf3 postgresql-client netcat mosh -y
