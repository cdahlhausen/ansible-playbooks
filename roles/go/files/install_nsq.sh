#!/bin/bash
#
# Install the NSQ binaries, if they are not already installed.
#

if [ ! -e ~/go/bin/nsqd ]; then
    curl "https://s3.amazonaws.com/bitly-downloads/nsq/nsq-0.3.0.linux-amd64.go1.3.3.tar.gz" > nsq-0.3.0.linux-amd64.go1.3.3.tar.gz
    tar -xzf nsq-0.3.0.linux-amd64.go1.3.3.tar.gz
    cp nsq-0.3.0.linux-amd64.go1.3.3/bin/* ~/go/bin
    rm nsq-0.3.0.linux-amd64.go1.3.3.tar.gz
    rm -rf nsq-0.3.0.linux-amd64.go1.3.3
fi
