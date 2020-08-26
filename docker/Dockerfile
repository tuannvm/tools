FROM mozilla/sops:v3.6 AS sops-builder
FROM hashicorp/terraform:0.12.29 AS terraform-builder

###

FROM ubuntu:18.04

ENV BIN_PATH=/usr/local/bin
ENV HELM_VERSION=2.12.2
ENV KUBECTL_VERSION=v1.13.0
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y telnet \
                       git \
                       wget curl \
                       iputils-ping dnsutils \
                       traceroute \
                       net-tools \
                       iproute2 \
                       iperf3 \
                       postgresql-client \
                       netcat httping httperf nmap \
                       vim jq \
                       awscli

RUN curl -L https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xzC ${BIN_PATH}/ && \
    mv $BIN_PATH/linux-amd64/helm $BIN_PATH/ && \
    rm -rf $BIN_PATH/linux-amd64/

RUN curl -S -L -f https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o ${BIN_PATH}/kubectl && \
    chmod +x ${BIN_PATH}/kubectl

COPY --from=sops-builder /go/bin/sops ${BIN_PATH}/
COPY --from=terraform-builder /bin/terraform ${BIN_PATH}/
