# shellcheck shell=bash
# no need for shebang - this file is loaded from charts.d.plugin
# SPDX-License-Identifier: GPL-3.0-or-later

# netdata
# real-time performance and health monitoring, done right!
# (C) 2016 Costa Tsaousis <costa@tsaousis.gr>
#

# if this chart is called X.chart.sh, then all functions and global variables
# must start with X_

# _update_every is a special variable - it holds the number of seconds
# between the calls of the _update() function
speedtest_update_every=120

# the priority is used to sort the charts on the dashboard
# 1 = the first chart
speedtest_priority=150000

# global variables to store our collected data
# remember: they need to start with the module name speedtest_
speedtest_download=0   
speedtest_upload=0
speedtest_download_bytes=0
speedtest_upload_bytes=0
speedtest_idle_latency=0
speedtest_download_latency=0
speedtest_upload_latency=0
speedtest_idle_jitter=0
speedtest_download_jitter=0
speedtest_upload_jitter=0
speedtest_packetloss=0

speedtest_get() {
  # do all the work to collect / calculate the values
  # for each dimension
  #
  # Remember:
  # 1. KEEP IT SIMPLE AND SHORT
  # 2. AVOID FORKS (avoid piping commands)
  # 3. AVOID CALLING TOO MANY EXTERNAL PROGRAMS
  # 4. USE LOCAL VARIABLES (global variables may overlap with other modules)

  output=$(speedtest --format=csv)
  
  speedtest_download=$(echo "$output" | awk -F, '{print $6}' | tr -d '"')
  speedtest_upload=$(echo "$output" | awk -F, '{print $7}' | tr -d '"')
  speedtest_download_bytes=$(echo "$output" | awk -F, '{print $8}' | tr -d '"')
  speedtest_upload_bytes=$(echo "$output" | awk -F, '{print $9}' | tr -d '"')
  speedtest_idle_latency=$(echo "$output" | awk -F, '{print $3}' | tr -d '"')
  speedtest_download_latency=$(echo "$output" | awk -F, '{print $12}' | tr -d '"')
  speedtest_upload_latency=$(echo "$output" | awk -F, '{print $16}' | tr -d '"')
  speedtest_idle_jitter=$(echo "$output" | awk -F, '{print $4}' | tr -d '"')
  speedtest_download_jitter=$(echo "$output" | awk -F, '{print $13}' | tr -d '"')
  speedtest_upload_jitter=$(echo "$output" | awk -F, '{print $17}' | tr -d '"')
  speedtest_packetloss=$(echo "$output" | awk -F, '{print $5}' | tr -d '"')
  # this should return:
  #  - 0 to send the data to netdata
  #  - 1 to report a failure to collect the data

  return 0
}

# _check is called once, to find out if this chart should be enabled or not
speedtest_check() {
  # this should return:
  #  - 0 to enable the chart
  #  - 1 to disable the chart

  # check something
  
  # check that we can collect data
  speedtest_get || return 1

  return 0
}

# _create is called once, to create the charts
speedtest_create() {
  cat << EOF
CHART speedtest.download '' 'Download Bandwidth' 'bps' 'bandwidth' 'speedtest.download' area $((speedtest_priority)) $speedtest_update_every '' 'charts.d.plugin' 'speedtest'
DIMENSION speedtest.download '' absolute 1 1
CHART speedtest.upload '' 'Upload Bandwidth' 'bps' 'bandwidth' 'speedtest.upload' area $((speedtest_priority)) $speedtest_update_every '' 'charts.d.plugin' 'speedtest'
DIMENSION speedtest.upload '' absolute 1 1
CHART speedtest.packetloss '' 'Packet Loss' 'packet loss %' 'packet loss' 'speedtest.packetloss' line $((speedtest_priority)) $speedtest_update_every '' 'charts.d.plugin' 'speedtest'
DIMENSION speedtest.packetloss '' percentage-of-absolute-row 1 1
CHART speedtest.idle_latency '' 'Idle Latency' 'milliseconds' 'latency' 'speedtest.idle_latency' line $((speedtest_priority)) $speedtest_update_every '' 'charts.d.plugin' 'speedtest'
DIMENSION speedtest.idle_latency '' absolute 1 1
CHART speedtest.download_latency '' 'Download Latency' 'milliseconds' 'latency' 'speedtest.download_latency' line $((speedtest_priority)) $speedtest_update_every '' 'charts.d.plugin' 'speedtest'
DIMENSION speedtest.download_latency '' absolute 1 1
CHART speedtest.upload_latency '' 'Upload Latency' 'milliseconds' 'latency' 'speedtest.upload_latency' line $((speedtest_priority)) $speedtest_update_every '' 'charts.d.plugin' 'speedtest'
DIMENSION speedtest.upload_latency '' absolute 1 1
CHART speedtest.idle_jitter '' 'Idle Jitter' 'milliseconds' 'jitter' 'speedtest.idle_jitter' line $((speedtest_priority)) $speedtest_update_every '' 'charts.d.plugin' 'speedtest'
DIMENSION speedtest.idle_jitter '' absolute 1 1
CHART speedtest.download_jitter '' 'Download Jitter' 'milliseconds' 'jitter' 'speedtest.download_jitter' line $((speedtest_priority)) $speedtest_update_every '' 'charts.d.plugin' 'speedtest'
DIMENSION speedtest.download_jitter '' absolute 1 1
CHART speedtest.upload_jitter '' 'Upload Jitter' 'milliseconds' 'jitter' 'speedtest.upload_jitter' line $((speedtest_priority)) $speedtest_update_every '' 'charts.d.plugin' 'speedtest'
DIMENSION speedtest.upload_jitter '' absolute 1 1
CHART speedtest.download_bytes '' 'Bytes downloaded' 'bytes' 'bandwidth' 'speedtest.download_bytes' line $((speedtest_priority)) $speedtest_update_every '' 'charts.d.plugin' 'speedtest'
DIMENSION speedtest.download_bytes '' absolute 1 1
CHART speedtest.upload_bytes '' 'Bytes uploaded' 'bytes' 'bandwidth' 'speedtest.upload_bytes' line $((speedtest_priority)) $speedtest_update_every '' 'charts.d.plugin' 'speedtest'
DIMENSION speedtest.upload_bytes '' absolute 1 1
EOF

  return 0
}

# _update is called continuously, to collect the values
speedtest_update() {
  # the first argument to this function is the microseconds since last update
  # pass this parameter to the BEGIN statement (see below).

  speedtest_get || return 1

  # write the result of the work.
  cat << VALUESEOF
BEGIN speedtest.download $1
SET speedtest.download = $speedtest_download
END
BEGIN speedtest.upload $1
SET speedtest.upload = $speedtest_upload
END
BEGIN speedtest.packetloss $1
SET speedtest.packetloss = $speedtest_packetloss
END
BEGIN speedtest.idle_latency $1
SET speedtest.idle_latency = $speedtest_idle_latency
END
BEGIN speedtest.download_latency $1
SET speedtest.download_latency = $speedtest_download_latency
END
BEGIN speedtest.upload_latency $1
SET speedtest.upload_latency = $speedtest_upload_latency
END
BEGIN speedtest.idle_jitter $1
SET speedtest.idle_jitter = $speedtest_idle_jitter
END
BEGIN speedtest.download_jitter $1
SET speedtest.download_jitter = $speedtest_download_jitter
END
BEGIN speedtest.upload_jitter $1
SET speedtest.upload_jitter = $speedtest_upload_jitter
END
BEGIN speedtest.download_bytes $1
SET speedtest.download_bytes = $speedtest_download_bytes
END
BEGIN speedtest.upload_bytes $1
SET speedtest.upload_bytes = $speedtest_upload_bytes
END
VALUESEOF

  return 0
}
