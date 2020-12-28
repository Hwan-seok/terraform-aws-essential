#!/bin/bash

apt update -y
apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update -y
apt-cache policy docker-ce
apt install docker-ce -y

# sudo systemctl status docker
usermod -aG docker ubuntu
systemctl enable docker
docker pull kylemanna/openvpn
mkdir ovpn-data

