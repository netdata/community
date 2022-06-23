echo "BEGIN"
echo "NETDATA_HOST_NAME=${NETDATA_HOST_NAME}"
echo "NETDATA_FORK=${NETDATA_FORK}"
echo "NETDATA_BRANCH=${NETDATA_BRANCH}"
echo "NETDATA_PARENT_NAME=${NETDATA_PARENT_NAME}"
echo "NETDATA_CLOUD_URL=${NETDATA_CLOUD_URL}"
echo "NETDATA_CLOUD_TOKEN=${NETDATA_CLOUD_TOKEN}"
echo "NETDATA_CLOUD_ROOMS=${NETDATA_CLOUD_ROOMS}"

# run this first
${RUN_THIS_FIRST}

# create someuser user
sudo adduser someuser

# set editor
echo 'setting editor'
export VISUAL="/usr/bin/vi"
export EDITOR="$VISUAL"

# install netdata
if [ "${NETDATA_FORK}" = "kickstart" ]; then
    echo 'installing netdata using kickstart'
    wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh --claim-token ${NETDATA_CLOUD_TOKEN} --claim-rooms ${NETDATA_CLOUD_ROOMS} --claim-url ${NETDATA_CLOUD_URL}
else
    echo 'installing netdata from fork/branch'
    rm -r -f netdatatmpdir
    mkdir netdatatmpdir
    sudo curl -Ss 'https://raw.githubusercontent.com/netdata/netdata/master/packaging/installer/install-required-packages.sh' > netdatatmpdir/install-required-packages.sh && bash netdatatmpdir/install-required-packages.sh --dont-wait --non-interactive netdata
    sudo curl -Ss 'https://raw.githubusercontent.com/netdata/netdata/master/packaging/installer/install-required-packages.sh' > netdatatmpdir/install-required-packages.sh && bash netdatatmpdir/install-required-packages.sh --dont-wait --non-interactive netdata-all
    git clone --branch ${NETDATA_BRANCH} "https://github.com/${NETDATA_FORK}.git" --depth=100
    cd /netdata
    git submodule update --init --recursive
    sudo ./netdata-installer.sh --dont-wait

    echo 'claiming to cloud'
    sudo netdata-claim.sh -token=${NETDATA_CLOUD_TOKEN} -rooms=${NETDATA_CLOUD_ROOMS} -url=${NETDATA_CLOUD_URL}

fi

# set up each host

################################################
# ml-demo-parent
################################################
if [ "${NETDATA_HOST_NAME}" = "ml-demo-parent" ]; then

    echo 'creating netdata.conf'
    sudo cat <<EOT > /etc/netdata/netdata.conf
[global]
    run as user = netdata
[ml]
    maximum num samples to train = 14400
    minimum num samples to train = 900
    train every = 900
    hosts to skip from training = ml-demo-ml-enabled*
EOT

echo "setting up streaming for ${NETDATA_PARENT_NAME}"
    # create stream.conf file
    sudo cat <<EOT > /etc/netdata/stream.conf
[XXX]
    enabled = yes
    default memory mode = dbengine
    health enabled by default = auto
    allow from = *
    multiple connections = allow
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 15 -t 160s") | sudo crontab - -u someuser
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/2 * * * * stress-ng -c 0 -l 20 -t 140s") | sudo crontab - -u someuser

################################################
# ml-demo-ml-enabled
################################################
elif [ "${NETDATA_HOST_NAME}" = "ml-demo-ml-enabled" ]; then

    echo 'creating netdata.conf'
    sudo cat <<EOT > /etc/netdata/netdata.conf
[global]
    run as user = netdata
[ml]
    maximum num samples to train = 14400
    minimum num samples to train = 900
    train every = 900
EOT

    echo "setting up streaming to ${NETDATA_PARENT_NAME}"
    # stream to ml-demo-parent
    # create stream.conf file
    sudo cat <<EOT > /etc/netdata/stream.conf
[stream]
    enabled = yes
    destination = XXX:19999
    api key = XXX
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/2 * * * * stress-ng -c 0 -l 10 -t 180s") | sudo crontab - -u someuser
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 15 -t 200s") | sudo crontab - -u someuser

################################################
# ml-demo-ml-enabled-meetup
################################################
elif [ "${NETDATA_HOST_NAME}" = "ml-demo-ml-enabled-meetup" ]; then

    echo 'creating netdata.conf'
    sudo cat <<EOT > /etc/netdata/netdata.conf
[global]
    run as user = netdata
[ml]
    maximum num samples to train = 14400
    minimum num samples to train = 900
    train every = 900
EOT

    echo "setting up streaming to ${NETDATA_PARENT_NAME}"
    # stream to ml-demo-parent
    # create stream.conf file
    sudo cat <<EOT > /etc/netdata/stream.conf
[stream]
    enabled = yes
    destination = XXX:19999
    api key = XXX
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/2 * * * * stress-ng -c 0 -l 10 -t 180s") | sudo crontab - -u someuser
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 15 -t 200s") | sudo crontab - -u someuser

################################################
# ml-demo-ml-enabled-orphan
################################################
elif [ "${NETDATA_HOST_NAME}" = "ml-demo-ml-enabled-orphan" ]; then

    echo 'creating netdata.conf'
    sudo cat <<EOT > /etc/netdata/netdata.conf
[global]
    run as user = netdata
[ml]
    maximum num samples to train = 14400
    minimum num samples to train = 900
    train every = 900
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/2 * * * * stress-ng -c 0 -l 10 -t 180s") | sudo crontab - -u someuser
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 15 -t 200s") | sudo crontab - -u someuser

################################################
# ml-demo-ml-disabled-orphan
################################################
elif [ "${NETDATA_HOST_NAME}" = "ml-demo-ml-disabled-orphan" ]; then

    echo 'creating netdata.conf'
    sudo cat <<EOT > /etc/netdata/netdata.conf
[global]
    run as user = netdata
[ml]
    enabled = no
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/2 * * * * stress-ng -c 0 -l 10 -t 180s") | sudo crontab - -u someuser
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 15 -t 200s") | sudo crontab - -u someuser

################################################
# else
################################################
else

    echo 'creating netdata.conf'
    sudo cat <<EOT > /etc/netdata/netdata.conf
[global]
    run as user = netdata
[ml]
    enabled = no
EOT

    echo "setting up streaming to ${NETDATA_PARENT_NAME}"
    # stream to ml-demo-parent
    # create stream.conf file
    sudo cat <<EOT > /etc/netdata/stream.conf
[stream]
    enabled = yes
    destination = XXX:19999
    api key = XXX
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/1 * * * * stress-ng -c 0 -l 25 -t 90s") | sudo crontab - -u someuser

fi

# enable alarms collector

echo "setting up python collectors"
    # create stream.conf file
    sudo cat <<EOT > /etc/netdata/python.d.conf
alarms: yes
EOT

echo "configure alarms.conf"
    # create /python.d/alarms.conf file
    sudo cat <<EOT > /etc/netdata/python.d/alarms.conf
ml:
  update_every: 5
  url: 'http://127.0.0.1:19999/api/v1/alarms?all'
  status_map:
    CLEAR: 0
    WARNING: 1
    CRITICAL: 2
  collect_alarm_values: true
  alarm_status_chart_type: 'stacked'
  alarm_contains_words: 'ml_1min'
EOT

# configure ml based alerts

echo "configure ml based alarms"
    # create /health.d/ml.conf file
    sudo cat <<EOT > /etc/netdata/health.d/ml.conf
template: ml_1min_cpu_usage
      on: system.cpu
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling anomaly rate for each system.cpu dimension

template: ml_1min_io_usage
      on: system.io
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling 5 minute anomaly rate for each system.io dimension

template: ml_1min_ram_usage
      on: system.ram
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling anomaly rate for each system.ram dimension

template: ml_1min_net_usage
      on: system.net
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling anomaly rate for each system.net dimension

template: ml_1min_ip_usage
      on: system.ip
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling anomaly rate for each system.ip dimension

template: ml_1min_processes_usage
      on: system.processes
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling anomaly rate for each system.processes dimension

template: ml_1min_node_anomaly_rate
      on: anomaly_detection.anomaly_rate
      os: linux
   hosts: *
  lookup: average -1m for anomaly_rate
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (2) : (5))
    crit: \$this > ((\$status == \$CRITICAL) ? (5) : (100))
    info: rolling node level anomaly rate
EOT

# run this last
${RUN_THIS_LAST}