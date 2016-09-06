#!/bin/bash

# On Ubuntu, cannot use dash, apparently
if [[ `awk '{print $1; exit}' /etc/issue` =~ buntu ]]; then
    echo "dash dash/sh boolean false" | sudo debconf-set-selections -v
    sudo dpkg-reconfigure dash -f noninteractive
fi

# Compile Eesen
cd
git clone -b lorelei https://github.com/srvk/eesen.git
cd eesen/tools
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

# Install kenlm rather than SRILM
cd
sudo yum install -y cmake boost-devel bzip2-devel eigen3-devel
(cd kenlm; cmake . && make -j)


# We also need SoX
cd
wget -O - --quiet http://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.bz2 | tar -xvjf -
(cd sox-14.4.2; make -s -j; sudo make install)

# Install the Eesen Babel experiments (and the Kaldi scripts)
cd
git clone -b babel-exps https://fmetze@bitbucket.org/mgowayyed/lorelei-audio.git babel-exps
# maybe use http://dalibornasevic.com/posts/2-permanently-remove-files-and-folders-from-git-repo
git clone https://github.com/kaldi-asr/kaldi
(cd kaldi; git reset --hard b77e93095b81b9e93322b90e74d12b4469089e17)
# they changed the calls to arpa2fst, does not concern us here
(cd babel-egps/egs; ln -s ../../kaldi/egs/babel .)
(cd /media/s3fs; unzip /media/s3fs/IARPA-babel201b-v0.2b.build_LDC2016E08.zip; ln -s IARPA-babel201b-v0.2b.build 201-B)
