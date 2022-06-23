echo "BEGIN RUN_THIS_LAST"

# install docker
echo "install docker"
sudo apt-get update -y
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sudo echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# run netdata-mlapp via docker
echo "run netdata-mlapp via docker"
sudo docker run -d --network="host" --name=netdata-ml-app-1 \
  -p 29999:29999 \
  --env NETDATAMLAPP_HOSTS=127.0.0.1:19999 \
  --env NETDATAMLAPP_SCRAPE_CHILDREN=yes \
  --restart unless-stopped \
  andrewm4894/netdata-ml-app:latest

# mod group to enable container name discovery
sudo usermod -a -G docker netdata

# create bad users
sudo adduser memstealer
(sudo crontab -l -u memstealer 2>/dev/null; echo "0 */4 * * * stress-ng --vm 2 --vm-bytes 2G -t 20s") | sudo crontab - -u memstealer
(sudo crontab -l -u memstealer 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 5 -t 200s") | sudo crontab - -u memstealer
sudo adduser cpuhog
(sudo crontab -l -u cpuhog 2>/dev/null; echo "30 */4 * * * stress-ng -c 0 -l 70 -t 30s") | sudo crontab - -u cpuhog
(sudo crontab -l -u cpuhog 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 5 -t 200s") | sudo crontab - -u cpuhog

# install stress-ng
sudo apt-get install stress-ng -y

echo "install gremlin"
# Add packages needed to install and verify gremlin (already on many systems)
sudo apt update && sudo apt install -y apt-transport-https dirmngr
# Add the Gremlin repo
echo "deb https://deb.gremlin.com/ release non-free" | sudo tee /etc/apt/sources.list.d/gremlin.list
# Import the GPG key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9CDB294B29A5B1E2E00C24C022E8EF3461A50EF6
# Install Gremlin client and daemon
sudo apt update && sudo apt install -y gremlin gremlind

# restart netdata
echo "restart netdata"
sudo systemctl restart netdata