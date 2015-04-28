#!/bin/bash

echo "This script requires root privileges, you will be asked your sudo password"

# Setup PuppetLabs repository
DISTRO=$(grep DISTRIB_CODENAME /etc/upstream-release/lsb-release|sed 's/.*=//')
echo "Distro appears to be $DISTRO..."
if ! dpkg -l puppetlabs-release ; then
  echo "Grabbing puppet release..."
  wget -q https://apt.puppetlabs.com/puppetlabs-release-$DISTRO.deb
  sudo dpkg -i puppetlabs-release-$DISTRO.deb
  sudo apt-get update -y -q
  rm -f puppetlabs-release-$DISTRO.deb 2>/dev/null
else
  echo "puppet release already installed, skipping"
fi

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
