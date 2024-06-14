
### docker
```bash
sudo apt-get update
export http_proxy=http://10.1.1.55:22112
export https_proxy=http://10.1.1.55:22112
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo mkdir -p /etc/systemd/system/docker.service.d
cd /etc/systemd/system/docker.service.d
sudo vim http-proxy.conf
# [Service]
# Environment="HTTP_PROXY=http://127.0.0.1:22112/"
# Environment="HTTPS_PROXY=http://127.0.0.1:22112/"
# Environment="NO_PROXY=localhost,127.0.0.0/8,192.168.*,10.*"
sudo systemctl daemon-reload
sudo systemctl show --property Environment docker
sudo systemctl restart docker
cd ~
sudo docker run hello-world
```
