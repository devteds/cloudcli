FROM ruby:3.0.2-slim

ENV SUMMARY="A Devteds Tool. Containerized CLI Tools" \
    DESCRIPTION="A Devteds Tool. Containerized CLI and Tools: AWS, doctl, Terrafrom, KubeCtl, Helm, Ruby, Python, Git, OpenSSH"

ENV PATH $PATH:/root/.local/bin
ENV PATH=$PATH:/cloudcli-home/bin:/usr/local/go/bin

LABEL \
    maintainer="Chandra Shettigar <@devteds.com>" \
    summary="$SUMMARY" \
    name="devteds/cloudcli" \
    description="$DESCRIPTION"

RUN mkdir /cloudcli-home
RUN mkdir /cloudcli-home/bin
RUN mkdir /cloudcli-home/workspace
RUN mkdir /cloudcli-home/temp

WORKDIR /cloudcli-home/workspace

# Packages

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl && \
    apt-get install -y gettext && \
    apt-get install -y openssh-client && \
    apt-get install -y zip && \
    apt-get install -y git-core && \
    apt-get install -y wget && \
    apt-get install -y jq && \
    apt-get install -y build-essential && \
    apt-get install -y make

# Python3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# RUN apt-get install -y python3.7 && \
#     ln -s /usr/bin/python3.7 /usr/bin/python && \
#     ln -s /usr/bin/python3.7 /usr/bin/py

# RUN apt-get install -y wget build-essential libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev && \
#     wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz && \
#     tar xzf Python-3.9.7.tgz && \
#     cd Python-3.9.7 
#     ./configure --enable-optimizations && \
#     make altinstall

# wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
# tar xzf Python-3.9.7.tgz
# cd Python-3.9.7
# ./configure --enable-optimizations
# make altinstall

# RUN apt-get install -y software-properties-common && \
#     add-apt-repository universe && \
#     apt-get update && \
#     apt-get install -y python3.7 && \
#     apt-get install python3-pip && \
#     ln -s /usr/bin/python3.7 /usr/bin/python && \
#     ln -s /usr/bin/python3.7 /usr/bin/py

# Terraform ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ENV TERRAFORM_VERSION=1.1.2
ENV TERRAFORM_SHA256SUM=734efa82e2d0d3df8f239ce17f7370dabd38e535d21e64d35c73e45f35dfa95c

RUN cd /cloudcli-home/temp && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# AWC CLI ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RUN apt-get update --fix-missing && \
    apt-get install -y awscli && \
    apt-get install -y groff && \
    curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x /usr/bin/aws-iam-authenticator

# Docker Client ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TODO: Ensure only docker client is installed or enabled
ENV DOCKERVERSION=20.10.12
RUN cd /cloudcli-home/temp && \
    curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz && \
    tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker && \
    rm docker-${DOCKERVERSION}.tgz

ENV DOCKER_COMPOSE_VERSION=v2.2.3 
RUN DC_DOWNLOAD_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" && \
    curl -L ${DC_DOWNLOAD_URL} -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Go: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   https://golang.org/doc/install#code
RUN cd /cloudcli-home/temp && \
    wget https://golang.org/dl/go1.15.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.15.3.linux-amd64.tar.gz && \
    rm -rf go1.15.3.linux-amd64.tar.gz


# # Helm3: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# #   https://helm.sh/docs/intro/install/

# RUN cd /cloudcli-home/temp && \
#     git clone https://github.com/helm/helm.git && \
#     cd helm && \
#     make && \
#     cp bin/helm /usr/local/bin/

# Kubectl ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ENV KUBECTL_VERSION=v1.23.1
RUN cd /cloudcli-home/temp && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# DigitalOcean CLI ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ENV DO_VERSION=1.68.0
RUN cd /cloudcli-home/temp && \
    wget https://github.com/digitalocean/doctl/releases/download/v${DO_VERSION}/doctl-${DO_VERSION}-linux-amd64.tar.gz && \
    tar xf doctl-${DO_VERSION}-linux-amd64.tar.gz && \
    mv ./doctl /usr/local/bin/


# Rancher: RKE
ENV RKE_VERSION=1.3.3
# RUN curl -s https://api.github.com/repos/rancher/rke/releases/latest | grep download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -
RUN cd /cloudcli-home/temp && \
    echo https://github.com/rancher/rke/releases/download/v${RKE_VERSION}/rke_linux-amd64 | wget -qi -  && \
    chmod +x rke_linux-amd64 && \
    mv rke_linux-amd64 /usr/local/bin/rke && \
    rke --version

# Misc tools

RUN apt-get install -y vim && \
    apt-get install -y direnv

# ---

COPY ./dot_bashrc.sh /root/.bashrc_ext
RUN echo 'source /root/.bashrc_ext' >> /root/.bashrc

COPY ./bin/boot.sh /cloudcli-home/bin/boot.sh
COPY ./bin/version.sh /cloudcli-home/bin/version.sh
RUN chmod +x /cloudcli-home/bin/boot.sh
RUN chmod +x /cloudcli-home/bin/version.sh

RUN cd /cloudcli-home/temp && rm -rf *

ENV WORKDIR=/cloudcli-home/workspace
# RUN direnv allow /cloudcli-home/workspace/

CMD ["/cloudcli-home/bin/boot.sh"]
