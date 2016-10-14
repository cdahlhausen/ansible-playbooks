#!/bin/bash
#
# This must be run as root, since the tar command extracts the
# Go binaries into /usr/local.

if [ ! -e /usr/local/go ];
then
    curl "https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz" > go1.4.linux-amd64.tar.gz
    tar -C /usr/local -xzf go1.4.linux-amd64.tar.gz
    rm go1.4.linux-amd64.tar.gz
    rm -rf go1.4.linux-amd64
fi
