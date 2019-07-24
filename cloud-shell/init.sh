#!/bin/bash

set -e

mkdir -p ~/.cloudshell
touch ~/.cloudshell/no-apt-get-warning

BIN_PATH=/usr/local/bin
HELM_VERSION=v2.14.0
KUBECTL_VERSION=v1.13.0
TERRAFORM_VERSION=0.12.5

sudo apt-get update
sudo apt-get install telnet git curl iputils-ping dnsutils traceroute net-tools iproute2 iperf3 postgresql-client netcat -y

mkdir -p $BIN_PATH

cd /tmp/

curl -S -L -f https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o ${BIN_PATH}/kubectl && \
    sudo chmod +x ${BIN_PATH}/kubectl

curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > ${BIN_PATH}/helm && \
    chmod +x ${BIN_PATH}/helm && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

cd --
