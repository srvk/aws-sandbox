#!/bin/bash

# this script is being copied to the VM, and would be helpful to initialize VMs
# that are part of a cluster

echo `ifconfig eth0 | awk '/inet addr/ {sub("addr:",""); print $2}'` `uname -n` | sudo tee -a /etc/hosts
sudo munged -f

if [ -d /opt/nvidia/cuda ]; then
    echo "Assuming I am a client"

    # Set this variable, or get user_data, ...
    export headnode="ip-172-30-0-6"
    echo $headnode $headnode | sed -e 's/ip-//' -e 's/-/./' -e 's/-/./' -e 's/-/./' | sudo tee -a /etc/hosts
    echo -e "\$pbsserver ${headnode}\n\$logevent 255" | sudo tee /etc/torque/mom/config

    echo `uname -n` "np=`nvidia-smi -L|wc -l` gpus=`nvidia-smi -L|wc -l`" | \
	ssh $headnode "sudo tee -a /var/lib/torque/server_priv/nodes"
    echo `ifconfig eth0|awk '/inet addr/ {sub("addr:",""); print $2}'` `uname -n` | \
	ssh $headnode "sudo tee -a /etc/hosts"
    sudo pbs_mom
    
else
    echo "Assuming I am the headnode"
    echo `uname -n` | sudo tee /etc/torque/server_name

    for n in "ip-170-30-0-141"; do
	:
	#echo "$n np=1 gpus=1" | sudo tee -a /var/lib/torque/server_priv/nodes
    done
    
    sudo pbs_server -ft create
    sudo trqauthd
    sudo qmgr -c "set server acl_hosts = `uname -n`"
    sudo qmgr -c "set server scheduling=true"
    sudo qmgr -c "create queue batch queue_type=execution"
    sudo qmgr -c "set queue batch started=true"
    sudo qmgr -c "set queue batch enabled=true"
    sudo qmgr -c "set queue batch resources_default.nodes=1"
    sudo qmgr -c "set queue batch resources_default.walltime=360000"
    sudo qmgr -c "set server default_queue=batch"
    sudo qmgr -c 'p s'    

    sudo killall -s 9 pbs_server
    sudo pbs_server
    sudo pbs_sched
    
fi

sshfs -o Ciphers=arcfour -C fmetze@rocks.is.cs.cmu.edu:/home/fmetze/ /home/fmetze


#### the below may be useful, too ###

# add other nodes to /etc/hosts, too (including local name to localhost)
#sudo echo `ifconfig eth0|awk '/inet addr/ {sub("addr:",""); print $2}'` `uname -n` >> /etc/hosts
#sudo echo `uname -n` > /etc/torque/server_name # this is the head node
# sudo nano /var/lib/torque/server_priv/nodes (on head, add compute nodes, e.g. 'ip-... np=1 gpus=1')
# munge key should be the same for server and clients
# sudo create-munge-key

# see https://wiki.archlinux.org/index.php/TORQUE
#   populate /etc/hosts (add ip-... name, too)
#   /etc/torque/server_name <- ip-... (server)
