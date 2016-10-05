#!/bin/bash

# On Ubuntu, cannot use dash, apparently
if [[ `awk '{print $1; exit}' /etc/issue` =~ buntu ]]; then
    echo "dash dash/sh boolean false" | sudo debconf-set-selections -v
    sudo dpkg-reconfigure dash -f noninteractive

    # install slurm (buggy in Ubuntu 16.04.1 LTS)
    sudo apt-get update
    sudo apt-get install -y munge
    sudo mkdir -p /etc/systemd/system/munge.service.d && echo -e "[Service]\nExecStart=\nExecStart=/usr/sbin/munged --syslog --force" | sudo tee /etc/systemd/system/munge.service.d/override.conf && sudo systemctl daemon-reload
    sudo systemctl enable munge
    sudo systemctl start munge
    sudo apt-get install -y slurm-llnl
    echo -e "ControlMachine=localhost\nAuthType=auth/munge\nCacheGroups=0\nCryptoType=crypto/munge\nJobCheckpointDir=/var/lib/slurm-llnl/checkpoint\nMpiDefault=none\nProctrackType=proctrack/pgid\nReturnToService=1\nSlurmctldPidFile=/var/run/slurm-llnl/slurmctld.pid\nSlurmctldPort=6817\nSlurmdPidFile=/var/run/slurm-llnl/slurmd.pid\nSlurmdPort=6818\nSlurmdSpoolDir=/var/lib/slurm-llnl/slurmd\nSlurmUser=slurm\nStateSaveLocation=/var/lib/slurm-llnl/slurmctld\nSwitchType=switch/none\nTaskPlugin=task/none\nInactiveLimit=0\nKillWait=30\nMinJobAge=300\nSlurmctldTimeout=300\nSlurmdTimeout=300\nWaittime=0\nFastSchedule=0\nSchedulerType=sched/backfill\nSchedulerPort=7321\nSelectType=select/cons_res\nSelectTypeParameters=CR_Core_Memory\nAccountingStorageType=accounting_storage/none\nClusterName=cluster\nJobCompType=jobcomp/none\nJobAcctGatherFrequency=30\nJobAcctGatherType=jobacct_gather/none\nSlurmctldDebug=3\nSlurmctldLogFile=/var/log/slurm-llnl/slurmctld.log\nSlurmdDebug=3\nSlurmdLogFile=/var/log/slurm-llnl/slurmd.log\nNodeName=localhost Procs=8 State=UNKNOWN\nPartitionName=standard Nodes=localhost Default=YES MaxTime=INFINITE State=UP" | sudo tee /etc/slurm-llnl/slurm.conf
    sudo touch /var/spool/job_state
    sudo systemctl enable slurmd
    sudo systemctl enable slurmctld
    sudo systemctl start slurmd
    sudo systemctl start slurmctld
fi

# We also need SoX
if [ -z `which sox` ]; then
    cd
    wget -O - --quiet http://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.bz2 | tar -xvjf -
    (cd sox-14.4.2 && ./configure && make -s -j && sudo make install)
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
wget -O - --quiet http://kheafield.com/code/kenlm.tar.gz |tar xz
(cd kenlm; cmake . && make -j)

# Install the Eesen Babel experiments (and the Kaldi scripts)
cd
git clone -b babel-exps https://fmetze@bitbucket.org/mgowayyed/lorelei-audio.git babel-exps
# maybe use http://dalibornasevic.com/posts/2-permanently-remove-files-and-folders-from-git-repo
git clone https://github.com/kaldi-asr/kaldi
(cd kaldi; git reset --hard b77e93095b81b9e93322b90e74d12b4469089e17)
# they changed the calls to arpa2fst, does not concern us here
(cd babel-exps/egs; ln -s ../../kaldi/egs/babel .)
#(cd /media/s3fs; unzip /media/s3fs/IARPA-babel201b-v0.2b.build_LDC2016E08.zip; ln -s IARPA-babel201b-v0.2b.build 201-B)
# patch the scoring software to handle Babel data in UTF-8
patch eesen/tools/sctk/bin/hubscr.pl < /vagrant/scripts/hubscr.diff
