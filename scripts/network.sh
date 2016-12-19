#!/bin/bash


# This manually installs SSHFS (on Ubuntu)
if false; then
    # This installs SSHFS
    # run it as a user that has sudo rights
    # preferably in the home folder
    cd

    # Get SSH in place (in addition to user_data)
    mkdir -pm 700 ~/.ssh
    cp /vagrant/id* ~/.ssh
    # rm -f /vagrant/secrets.sh*
    
    # This could be done as root or ec2-user
    git clone https://github.com/libfuse/sshfs.git
    cd sshfs
    autoreconf -i
    ./configure
    make -j -k || make
    sudo make install
    # maybe also use something like https://github.com/pcarrier/afuse

    # sshfs -C fmetze@rocks.is.cs.cmu.edu:/data/ASR5/ /data/ASR5 -o Ciphers=arcfour -o allow_other,uid=`id -u`,gid=`id -g`
fi
sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

# Get SSH stuff in place
#sudo su -l -c /vagrant/scripts/sshfs.sh -s /bin/bash ${user}
sudo mkdir -pm 777 /home/fmetze /data/MM3 /data/MM2 /data/MM1 \
     /data/ASR5 /data/ASR4 /data/ASR3 /data/ASR2 /data/ASR1 /pylon2/ir3l68p/metze \
     /oasis/projects/nsf/cmu139/fmetze /oasis/projects/nsf/cmu131/fmetze

# this user thing seems unreliable - i cannot log in again after this? 
# the sudo su ec2-user didn't work in the first place?
#cd /home/ec2-user
#ssh-keygen -f .ssh/id_rsa -P ""


# This manually installs S3FS (from https://github.com/bizmate/s3_mount.git)
if [[ `awk '{print $1; exit}' /etc/issue` =~ buntu ]]; then
    apt-get install -y automake autotools-dev g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config
    # libcurl4-openssl-dev libfuse-dev libxml2-dev libxml++2.6-dev libcrypto++-dev
else
    yum install -y libxml2-devel libcurl-devel fuse-devel openssl-devel
fi
if true; then
    cd
    git clone https://github.com/s3fs-fuse/s3fs-fuse
    cd s3fs-fuse/
    ./autogen.sh
    ./configure --prefix=/usr --with-openssl # See (*1)
    make -j -k || make
    make install
    
    mkdir -pm 777 /media/s3fs /media/ephemeral0/s3fs-cache
    sed -i 's/# user_allow_other/user_allow_other/' /etc/fuse.conf
    # echo "$AWS_KEY:$AWS_SECRETKEY" > ~/.passwd-s3fs
    # chmod 400 ~/.passwd-s3fs
    # s3fs -o use_cache=/media/ephemeral0/s3fs-cache -o use_rrs -o allow_other "fmetze-bucket:" /media/s3fs
fi

# Or use EFS service to access files via NFS
#mkdir -pm 777 /media/babel
#mount -t nfs4 -o nfsvers=4.1 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).fs-b4d516fd.efs.us-east-1.amazonaws.com:/ /media/babel
