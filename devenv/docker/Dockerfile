FROM golang:buster

RUN apt-get update && apt-get install -y git apt-utils curl tar wget
RUN git clone https://github.com/netdata/netdata.git netdata 
RUN chmod +x ./netdata/packaging/installer/install-required-packages.sh 
RUN ./netdata/packaging/installer/install-required-packages.sh netdata-all --non-interactive
RUN ./netdata/packaging/installer/kickstart.sh --non-interactive

EXPOSE 19999
ENTRYPOINT ["tail", "-f", "/dev/null"]
