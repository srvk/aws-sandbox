#!/bin/bash

# On Ubuntu, cannot use dash, apparently
if [[ `awk '{print $1; exit}' /etc/issue` =~ buntu ]]; then
    echo "dash dash/sh boolean false" | sudo debconf-set-selections -v
    sudo dpkg-reconfigure dash -f noninteractive
fi

# Compile Eesen
cd
git clone https://github.com/srvk/eesen.git
cd eesen/tools
git checkout lorelei
#git reset --hard 7c52021f3f0c884dbad4b67929907f63efd6d97a
make -j -k || make
cd ../src
if [ -d /opt/nvidia/cuda ]; then
    ./configure --shared --cudatk-dir=/opt/nvidia/cuda
elif [ -f "`which nvcc`" ]; then
    ./configure --shared --use-cuda=yes
else
    ./configure --shared --use-cuda=no
fi
make -j -k || make
# the trick above should speed up compilation ...
