FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="${PATH}:/usr/local/go/bin"

WORKDIR /root/
# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends apt-utils \
                                               ca-certificates \
                                               curl \
                                               gnupg \
                                               lsb-release && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    NODE_MAJOR=20 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs \
                                               flake8 \
                                               golang \
                                               python3-pip \
                                               nodejs \
                                               shellcheck \
                                               yamllint && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    npm install --global --unsafe-perm --force yarn && \
    [ "$(uname -m)" = "x86_64" ] && curl -o /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.1.0/hadolint-Linux-x86_64 && chmod +x /bin/hadolint; true

ADD https://raw.githubusercontent.com/netdata/netdata/master/packaging/installer/install-required-packages.sh /install-required-packages.sh

RUN chmod +x /install-required-packages.sh && \
    /install-required-packages.sh netdata-all --non-interactive --dont-wait && \
    apt-get install -y --no-install-recommends libprotobuf-c-dev \
                                               libprotobuf-dev \
                                               protobuf-c-compiler \
                                               protobuf-compiler && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY ./bash_aliases /root/.bash_aliases

EXPOSE 19999

CMD ["tail", "-f", "/dev/null"]
