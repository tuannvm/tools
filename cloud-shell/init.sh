#!/bin/bash

set -e

touch ~/.cloudshell/no-apt-get-warning

BIN_PATH=/usr/local/bin
HELM_VERSION=2.12.2
KUBECTL_VERSION=v1.13.0
TERRAFORM_VERSION=0.12.5

sudo apt-get update
sudo apt-get install telnet git curl iputils-ping dnsutils traceroute net-tools iproute2 iperf3 postgresql-client netcat -y

mkdir -p $BIN_PATH

cd /tmp/

curl -S -L -f https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xzC ${BIN_PATH}/ && \
    mv $BIN_PATH/linux-amd64/helm $BIN_PATH/ && \
    rm -rf $BIN_PATH/linux-amd64/

curl -S -L -f https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o ${BIN_PATH}/kubectl && \
    chmod +x ${BIN_PATH}/kubectl

curl -S -L -f https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip | bsdtar -xvf- -C $(BIN_PATH)

cd --