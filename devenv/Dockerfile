FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ARG ARCH=

WORKDIR /root/
RUN apt-get update && apt-get install -y --no-install-recommends git apt-utils curl tar wget yamllint shellcheck flake8 golang python3-pip  && rm -rf /var/lib/apt/lists/*
RUN bash < (curl -Sshttps://raw.githubusercontent.com/netdata/netdata/master/packaging/installer/install-required-packages.sh )

RUN if [ "${ARCH}" = "AMD64"]; then \
    wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.22.0/hadolint-Linux-x86_64 && chmod +x /bin/hadolint \
    else \
        echo "Hadolint is not available for this architecture; Skipping" \
    fi \
RUN export PATH=$PATH:/usr/local/go/bin
RUN go version


EXPOSE 19999
ENTRYPOINT ["tail", "-f", "/dev/null"]

