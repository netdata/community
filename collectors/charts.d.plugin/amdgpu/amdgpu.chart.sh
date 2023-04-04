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
amdgpu_update_every=

# the priority is used to sort the charts on the dashboard
# 1 = the first chart
amdgpu_priority=150000

# global variables to store our collected data
# remember: they need to start with the module name amdgpu_
amdgpu_vram_total=
amdgpu_vram_used=
amdgpu_busy_percent=
amdgpu_sclk=
amdgpu_mclk=

amdgpu_get() {
  # do all the work to collect / calculate the values
  # for each dimension
  #
  # Remember:
  # 1. KEEP IT SIMPLE AND SHORT
  # 2. AVOID FORKS (avoid piping commands)
  # 3. AVOID CALLING TOO MANY EXTERNAL PROGRAMS
  # 4. USE LOCAL VARIABLES (global variables may overlap with other modules)

  amdgpu_vram_total=$(cat /sys/class/drm/card0/device/mem_info_vram_total)
  amdgpu_vram_used=$(cat /sys/class/drm/card0/device/mem_info_vram_used)
  amdgpu_busy_percent=$(cat /sys/class/drm/card0/device/gpu_busy_percent)

  amdgpu_sclk=$(cat /sys/class/drm/card0/device/hwmon/hwmon*/freq1_input)
  amdgpu_mclk=$(cat /sys/class/drm/card0/device/hwmon/hwmon*/freq2_input)

  # this should return:
  #  - 0 to send the data to netdata
  #  - 1 to report a failure to collect the data

  return 0
}

# _check is called once, to find out if this chart should be enabled or not
amdgpu_check() {
  # this should return:
  #  - 0 to enable the chart
  #  - 1 to disable the chart

  return 0
}

# _create is called once, to create the charts
amdgpu_create() {
  # create the chart with 3 dimensions
  cat << EOF
CHART amdgpu.usage "" "Usage" "%"
DIMENSION busy
CHART amdgpu.vram "" "VRAM" "B"
DIMENSION total
DIMENSION used
CHART amdgpu.clock "" "Clock" "Hz"
DIMENSION sclk
DIMENSION mclk
EOF

  return 0
}

# _update is called continuously, to collect the values
amdgpu_update() {
  # the first argument to this function is the microseconds since last update
  # pass this parameter to the BEGIN statement (see bellow).

  amdgpu_get || return 1

  # write the result of the work.
  cat << VALUESEOF
BEGIN amdgpu.usage $1
SET busy = $amdgpu_busy_percent
END
BEGIN amdgpu.vram $1
SET total = $amdgpu_vram_total
SET used = $amdgpu_vram_used
END
BEGIN amdgpu.clock $1
SET sclk = $amdgpu_sclk
SET mclk = $amdgpu_mclk
END
VALUESEOF

  return 0
}