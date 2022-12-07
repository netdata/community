# Utilities

- [/airthings](./airthings/) - A Python script to wrangle some Airthings data.
- [/load_creator](./load_creator/) - A script to create some load.
- [`install-collector.sh`](./install-collector.sh) - A little helper script to install a third party or community collector from netdata/community.
  You can use it like this:

  ```bash
  # download the script and run it to install the `speedtest` collector
  sudo wget -O /tmp/install-collector.sh https://raw.githubusercontent.com/netdata/community/main/utilities/install-collector.sh && sudo bash /tmp/install-collector.sh charts.d.plugin/speedtest
  ```