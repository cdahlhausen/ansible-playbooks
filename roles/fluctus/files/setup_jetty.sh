#!/bin/bash
#
# setup_jetty.sh
#
# Sets up Jetty in the Fluctus project so we can
# run Solr and Fedora
#

if [ ! -e ~/aptrust/fluctus/jetty/lib ]; then
    . ~/.profile
    cd ~/aptrust/fluctus
    rails g hydra:jetty
fi
