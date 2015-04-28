#!/bin/bash

echo "This script requires root privileges, you will be asked your sudo password"

# Setup PuppetLabs repository
DISTRO=$(grep DISTRIB_CODENAME /etc/upstream-release/lsb-release|sed 's/.*=//')
echo "Distro appears to be $DISTRO..."
PUPPET_RELEASE=$(puppetlabs-release-$DISTRO.deb)
if ! dpkg -l puppetlabs-release ; then
  echo "OK Grabbing puppet release $PUPPET_RELEASE..."
  wget -q https://apt.puppetlabs.com/puppetlabs-release-$DISTRO.deb
  sudo dpkg -i puppetlabs-release-$DISTRO.deb
  sudo apt-get update -y -q
  rm -f puppetlabs-release-$DISTRO.deb 2>/dev/null
else
  echo "OK puppet release $PUPPET_RELEASE already installed, skipping"
fi

# Install puppet without the agent init script
sudo apt-get install git puppet-common hiera -y -q

# Get r10k
if gem list|grep r10k; then
  echo "OK skipping gem install r10k"
else
  echo "OK installing r10k"
  sudo gem install r10k 
fi

# Download uboxen code
cd /opt
[ ! -d /opt/mint-boxen ] && sudo git clone https://github.com/jbruce12000/mint-boxen.git
cd /opt/mint-boxen
r10k puppetfile install
sudo puppet apply install.pp

# Finish
echo -e "\n\nInstallation ended successfully (I hope).\n\nEnjoy Ubuntu Boxen running 'uboxen' at your shell prompt"
