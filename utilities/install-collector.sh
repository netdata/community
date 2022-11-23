#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

# netdata
# real-time performance and health monitoring, done right!
# (C) 2022

# This script installs community maintained collectors from netdata/community github repo

NETDATA_DIR="/etc/netdata"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit 1
fi

if [ ! -d $NETDATA_DIR ]; then
    printf "\nPlease update NETDATA_DIR in %s with the Netdata user configuration directory as mentioned in https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables\n" "$0"
    exit 1
fi

printf "\nYou are about to install a collector that is NOT developed or maintained by Netdata. Would you like to proceed? [y/n]"
read -r answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    printf "\nInstalling collector from community repo..."
else
    printf "\n\nExiting...\n\n"
    exit 1
fi

input=$1
collector=${input#*/}
suffix=".plugin/$collector"
plugin=${input%"$suffix"}

if [ "$plugin" == "python.d" ]; then
    file_ext=".py"
elif [ "$plugin" == "charts.d" ]; then
    file_ext=".sh"
elif [ "$plugin" == "go.d" ]; then
    file_ext=".go"
elif [ "$plugin" == "node.d" ]; then
    file_ext=".js"
fi

charts="https://raw.githubusercontent.com/netdata/community/main/collectors/$1/$collector.chart$file_ext"
config="https://raw.githubusercontent.com/netdata/community/main/collectors/$1/$collector.conf"
executable="/usr/libexec/netdata/$plugin/"
collector_conf="/etc/netdata/$plugin/"
conf="/etc/netdata/$plugin.conf"
enabled="\"$collector: yes\""
filecheck="$collector_conf/$collector.conf"

if [ -f "$filecheck" ]; then
  printf "\n\nA Netdata collector by this name already exists on this system. Exiting...\n\n"
  exit 1
fi

if command -v curl > /dev/null 2>&1; then
    cd "$executable" && { sudo curl -O "$charts" ; cd -; }
    cd "$collector_conf" && { sudo curl -O "$config" ; cd -; }
  elif command -v wget > /dev/null 2>&1; then
    sudo wget "$charts" -P "$executable"
    sudo wget "$config" -P "$collector_conf"
  else
    echo >&2 "Downloading failed because neither curl nor wget are available on this system."
    exit 1
  fi

sudo echo "$enabled" | tee -a "$conf"

if systemctl is-active --quiet netdata; then
    sudo systemctl restart netdata
    if ! sudo systemctl restart netdata; then
       printf "\nUnable to restart Netdata agent, please follow these instructions to restart manually: https://learn.netdata.cloud/docs/configure/start-stop-restart\n"
       exit 1
    fi
else
    printf "\nUnable to restart Netdata agent, please follow these instructions to restart manually: https://learn.netdata.cloud/docs/configure/start-stop-restart\n"
fi

printf "\nSuccessfully restarted Netdata agent"
printf "\n\nInstalled %s collector succesfully.\n\n" "$collector"
