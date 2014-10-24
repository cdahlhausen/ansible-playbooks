!#/bin/bash

cd /usr/local/src
sudo wget https://github.com/GrahamDumpleton/mod_wsgi/archive/4.3.0.tar.gz
sudo tar -zxvf 4.3.0.tar.gz
cd mod_wsgi-4.3.0/
sudo ./configure --with-python=/usr/bin/python3.4
sudo make
sudo make install
