# aws-sandbox

Create a VM on AWS with Vagrant and run ASR experiments


This repository allows you to create a VM with Vagrant, and then
run ASR experiments in it. Two main uses come to mind:

- quickly add nodes to your cluster, mounting the FS with SSHFS
- prepare VMs (or AMIs) for workshops, tutorials, etc.

## Building the VM (OVA or AMI) with Vagrant

If you already have the VM (AMI), you are good to go, and don't need to rebuild.
Read below on how to login.

To build, you need to do the following:

- clone this repository to your local machine
- install Vagrant (vagrantup.com)
- change to the working copy, and set environment variables in the shell:
  * export AWS_KEY='your-access-key'
  * export AWS_SECRET='your-secret-secret'
  * export AWS_KEYNAME='your-keyname'
  * export AWS_KEYPATH='your-keypath'
- install the vagrant-aws plugin and fetch an AWS dummy box
  - vagrant plugin install vagrant-aws
  - vagrant box add dummybox-aws https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
- create the VM
  - vagrant up --provider=aws
- enjoy
  - vagrant ssh gpu

vagrant ssh default

*) You may need to first subscribe to the AMI referred to in the Vagrantfile. If you see an
error message like below, please visit the AWS Marketplace link for the AMI first and click
the "Accept" link 

    OptInRequired => In order to use this AWS Marketplace product you need to accept terms and subscribe.
    To do so please visit http://aws.amazon.com/marketplace/pp?sku=cjsrmewvppzcgw06k8yab9o6s 


## Logging into the VM (OVA or AMI)

Log in.

## Running Experiments

Do stuff


## Troubleshooting

Read the documentation at the Speech Recognition Virtual Kitchen <https://github.com/srvk>


## Contact

Contact Florian Metze (<https://www.cs.cmu.edu/directory/fmetze>) or 
Eric Riebling (<https://www.cs.cmu.edu/directory/er1k>). 
