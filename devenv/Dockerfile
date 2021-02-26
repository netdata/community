FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root/
RUN apt-get update && apt-get install -y --no-install-recommends git apt-utils curl tar wget yamllint shellcheck flake8 golang python3-pip  && rm -rf /var/lib/apt/lists/*
RUN wget -O ./install-required-packages.sh https://raw.githubusercontent.com/netdata/netdata/master/packaging/installer/install-required-packages.sh && chmod +x ./install-required-packages.sh && ./install-required-packages.sh netdata-all --non-interactive
# Hadolint is vendored only for x86_64 architectures
RUN  [ "$(uname -m)" = "x86_64" ] && wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.22.0/hadolint-Linux-x86_64 && chmod +x /bin/hadolint; true
RUN export PATH=$PATH:/usr/local/go/bin
RUN go version

EXPOSE 19999
ENTRYPOINT ["tail", "-f", "/dev/null"]

