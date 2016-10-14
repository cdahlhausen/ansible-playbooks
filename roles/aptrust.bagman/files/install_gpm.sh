#!/bin/bash
#
# install_gpm.sh - Install the Go Package Manager
#
# This should be run as ubuntu on AWS servers, or as vagrant on Vagrant VM.
# Note the ~ in the cp command: it copies binaries into the user's local
# go bin. Also note the sudo. User ubuntu/vagrant should have passwordless
# sudo access.
#

# gpm is required to find and load nsq dependencies
go get github.com/pote/gpm
cd $GOPATH/src/github.com/pote/gpm
./configure
sudo make install
