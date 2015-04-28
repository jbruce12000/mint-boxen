#!/bin/bash

echo "This script requires root privileges, you will be asked your sudo password"

# Setup PuppetLabs repository
DISTRO=$(grep ppa /etc/apt/sources.list |grep main |head -1|cut -d " " -f 3)
wget -q https://apt.puppetlabs.com/puppetlabs-release-$DISTRO.deb
sudo dpkg -i puppetlabs-release-$DISTRO.deb
sudo apt-get update -y -q

# Install puppet without the agent init script
sudo apt-get install git puppet-common hiera -y -q

# Get & run librarian-puppet
sudo gem install r10k 
# Download uboxen code
cd /opt
[ ! -d /opt/ubuntu-boxen ] && sudo git clone https://github.com/jbruce12000/ubuntu-boxen.git
cd /opt/ubuntu-boxen
r10k puppetfile install
sudo puppet apply install.pp

# Finish
echo -e "\n\nInstallation ended successfully (I hope).\n\nEnjoy Ubuntu Boxen running 'uboxen' at your shell prompt"
