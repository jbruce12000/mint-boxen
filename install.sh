#!/bin/bash
set -e 
set -x

#--------------------------------------------------------------------------
function install_r10k() {
sudo apt-get install -y ruby
if sudo gem list|grep r10k; then
  echo "OK skipping gem install r10k"
else
  echo "OK installing r10k"
  sudo gem install r10k
fi
}

#--------------------------------------------------------------------------
function install_puppet_release() {
sudo apt-get install -y git puppet-common
DISTRO=$(grep DISTRIB_CODENAME /etc/upstream-release/lsb-release|sed 's/.*=//')
echo "Distro appears to be $DISTRO..."
PUPPET_RELEASE="puppetlabs-release-$DISTRO.deb"
if ! dpkg -l puppetlabs-release ; then
  echo "OK Grabbing puppet release $PUPPET_RELEASE..."
  wget -q https://apt.puppetlabs.com/puppetlabs-release-$DISTRO.deb -O puppetlabs-release-$DISTRO.deb
  sudo dpkg -i puppetlabs-release-$DISTRO.deb
else
  echo "OK puppet release $PUPPET_RELEASE already installed, skipping"
fi
}

#--------------------------------------------------------------------------
function install_uboxen_code() {
cd /opt
if [ -d /opt/mint-boxen ] ; then
  echo "OK, mint-boxen already installed...skipping clone"
else
  echo "OK, cloning mint-boxen to /opt/mint-boxen"
  sudo git clone https://github.com/jbruce12000/mint-boxen.git
  exec /opt/mint-boxen/install.sh
fi
}

#--------------------------------------------------------------------------
function run_puppet() {
cd /opt/mint-boxen
r10k puppetfile install
sudo puppet apply install.pp
}

#--------------------------------------------------------------------------
# main
#--------------------------------------------------------------------------
install_uboxen_code
install_puppet_release
install_r10k
run_puppet
echo -e "\n\nDone. Run 'uboxen' at your shell prompt in the future."
