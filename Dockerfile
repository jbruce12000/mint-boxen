FROM ubuntu
MAINTAINER Jason Bruce <jbruce12000@gmail.com>

RUN apt-get install wget -y -q

# Add some repos
# commented out because it is specific to precise
#RUN wget --no-check-certificate https://apt.puppetlabs.com/puppetlabs-release-precise.deb
#RUN dpkg -i puppetlabs-release-precise.deb


# Update & upgrades
RUN apt-get update -y -q
RUN apt-get upgrade -y

# Install puppet without the agent init script
RUN apt-get install puppet-common=2.7.25-1puppetlabs1 git sudo -y -q

# Install the app
RUN cd /opt && git clone https://github.com/jbruce12000/mint-boxen.git
RUN ln -s /opt/mint-boxen/uboxen /usr/local/bin/uboxen
RUN /opt/mint-boxen/uboxen 
