#!/bin/bash


if [ "$1" != "-f" ]; then
    echo "For Kali 2020 and other newer linux distros, this script is no longer needed."
    echo "Please use:" 
    echo "  sudo apt install docker.io" 
    echo "" 
    echo "If you still would like to use this script then append the flag -f"
    echo " ./install_docker_kali_x64.sh -f" 
    exit 1
fi


if fuser /var/lib/dpkg/lock > /dev/null 2>&1 
then 
        echo "Software management (APT) is already running. Cannot install docker right now."
        echo "Just wait a minute or two and try again"
        exit
fi


sudo apt-get update

# apt-get dependencies
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     software-properties-common

# Add gpg key for docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

if grep -q download.docker.com /etc/apt/sources.list; then
  echo sources.list already contains download.docker.com
else
  echo Adding to sources.list
  echo "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" | sudo tee --append /etc/apt/sources.list > /dev/null
fi

sudo apt-get update

sudo apt-get install docker-ce

# Start Docker on boot
sudo systemctl enable docker