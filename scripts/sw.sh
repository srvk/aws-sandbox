#!/bin/bash

if [[ `awk '{print $1; exit}' /etc/issue` =~ buntu ]]; then
    # Assume we are on Ubuntu (Virtualbox or AWS)
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y torque-client torque-server torque-scheduler torque-mom git zlib1g-dev \
         automake libtool autoconf patch subversion libatlas3-base sshfs g++ \
	 python2.7 python-minimal libtool-bin sox bc
    # fuse-sshfs
    #sudo apt-get install -y xfce4-panel xterm gnome-icon-theme lxappearance thunar

    sudo apt-get install -y cmake libboost-all-dev libbz2-dev libeigen3-dev liblzma-dev

    # from https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa/
    sudo add-apt-repository ppa:graphics-drivers/ppa
    sudo apt update -y
    sudo apt-get install -y nvidia-cuda-toolkit --no-install-recommends
#    sudo apt-get install -y nvidia-370-dev nvidia-cuda-toolkit --no-install-recommends
    sudo apt autoremove -y
    # need to reboot before using ...

else
    # Assume we are on AWS (Amazon Linux)
    sudo yum-config-manager --enable epel
    sudo yum update -y
    sudo yum install -y torque-client torque-server torque-scheduler torque-mom git zlib-devel \
         automake libtool autoconf patch subversion atlas-sse3-devel glib2-devel gcc-c++ \
         fuse fuse-devel fuse-sshfs cloud-utils
    sudo yum install -y cmake boost-devel bzip2-devel eigen3-devel
fi
