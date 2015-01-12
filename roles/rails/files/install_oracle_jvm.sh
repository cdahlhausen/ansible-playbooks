#!/bin/bash
#
# install_oracle_jvm.sh
#
# This script installs the Oracle JVM on Ubuntu 14.04 and sets
# it as the default JVM. This must be run as root or using sudo.
#

# The Oracle JVM installer presents an interactive screen asking
# us to agree to the Oracle license. In a remote install, we won't
# be able to interact with that screen, so let's agree ahead of
# time to the license.
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

# Add the apt repo that has the Oracle installer,
# get its package list and install Java 7.
add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get install -y oracle-java7-installer
