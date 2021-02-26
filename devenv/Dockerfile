FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root/
RUN apt-get update && apt-get install -y --no-install-recommends git apt-utils curl tar wget yamllint shellcheck flake8 golang python3-pip  && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/netdata/netdata.git netdata && chmod +x ./netdata/packaging/installer/install-required-packages.sh 
RUN ./netdata/packaging/installer/install-required-packages.sh netdata-all --non-interactive
RUN wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.22.0/hadolint-Linux-x86_64 && chmod +x /bin/hadolint
RUN git clone https://github.com/netdata/go.d.plugin go.d 
RUN export PATH=$PATH:/usr/local/go/bin
RUN go version


EXPOSE 19999
ENTRYPOINT ["tail", "-f", "/dev/null"]

