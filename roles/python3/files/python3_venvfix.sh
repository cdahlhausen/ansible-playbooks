!#/bin/bash

wget https://www.python.org/ftp/python/3.4.2/Python-3.4.2.tgz
tar -xzf Python-3.4.2.tgz
rm Python-3.4.2.tgz
cp -R Python-3.4.2/Lib/ensurepip /usr/lib/python3.4/ensurepip
rm -rf Python-3.4.2/
