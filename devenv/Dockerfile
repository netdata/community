FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root/
# hadolint ignore=DL3005,DL3008
# Dependencies required for netdata/netdata, netdata/go.d.plugin
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends git apt-utils curl tar wget yamllint shellcheck flake8 golang python3-pip ca-certificates  && rm -rf /var/lib/apt/lists/*
RUN curl -o ./install-required-packages.sh https://raw.githubusercontent.com/netdata/netdata/master/packaging/installer/install-required-packages.sh && chmod +x ./install-required-packages.sh && ./install-required-packages.sh netdata-all --non-interactive
# Hadolint is vendored only for x86_64 architectures
RUN  [ "$(uname -m)" = "x86_64" ] && curl -o /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.22.0/hadolint-Linux-x86_64 && chmod +x /bin/hadolint; true
RUN export PATH=$PATH:/usr/local/go/bin
RUN go version
# Dependencies required for netdata/dashboard
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt install -y --no-install-recommends yarn nodejs

EXPOSE 19999
ENTRYPOINT ["tail", "-f", "/dev/null"]

