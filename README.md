# PUSHING THE FRONTIERS OF SPEECH PROCESSING – WHAT DOES IT TAKE TO TACKLE NEW LANGUAGES AND DOMAINS? (INTERSPEECH 2016 Tutorial)

- The "aws-sandbox" is hosting the VM that will be made available to participants at this tutorial
- See more at: <http://www.interspeech2016.org/Tutorial-Descriptions#sthash.P84IDxeb.dpuf>
- **If you are a participant in the tutorial, please send your Amazon ID to Florian Metze (<https://www.cs.cmu.edu/directory/fmetze>) by e-mail**
- **We will then give you permissions to access the pre-built AMI _ami-1831460f_, which also contains the needed data**
- **Find more instructions and documentation [here](http://speechkitchen.org/interspeech-haitian-demo-vm/), or there, starting with [initial preparations.](IS2016-Preparing.md)**
- You can use the remainder of this repository to see how the VM is built, and re-built it yourself, adding other data (more Babel languages), or building a VM to run on other providers (e.g. your own cluster, etc.)

# aws-sandbox

Create a VM on AWS with Vagrant and run ASR experiments


This repository allows you to create a VM with Vagrant, and then
run ASR experiments in it. Two main uses come to mind:

- quickly add nodes to your cluster, mounting the FS with SSHFS
- prepare VMs (or AMIs) for workshops, tutorials, etc.

This repository allows you to build a Virtual Machine (VM) either as an OVA
(for running locally with VirtualBox) or an AMI (for running on AWS).
This documentation should also be helpful when you got one of those, and are 
trying to do stuff with them.


## Building the VM (OVA or AMI) with Vagrant

If you already have the VM (AMI), you are good to go, and don't need to rebuild.
Read below on how to login.

To build, you need to do the following:

1. clone this repository to your local machine
2. install Vagrant (vagrantup.com)
3. sign up for AWS and get somewhat familiar with it
4. change to the working copy, and set environment variables in the shell (I put this into a `secrets.sh` file which I do not check into git):
   - `export AWS_KEY='your-access-key'`
   - `export AWS_SECRET='your-secret-secret'`
   - `export AWS_KEYNAME='your-keyname'`
   - `export AWS_KEYPATH='your-keypath'`
5. install the vagrant-aws plugin and fetch an AWS dummy box
   - `vagrant plugin install vagrant-aws`
   - `vagrant box add dummybox-aws https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box`
6. create the VM
   - `vagrant up gpu --provider=aws`
   - wait a little while *)
7. enjoy
   - `vagrant ssh gpu`
   - vagrant ssh default

Please note that running a VM on AWS (or any other cloud provider) can result in costs, which
may be charged to your credit card (or some educational credits).

By default (subject to change without notice), this `Vagrantfile` will build a `gpu` machine
on AWS, to which you can log in to as "ec2-user".

*) You may need to first subscribe to the AMI referred to in the Vagrantfile. If you see an
error message like below, please visit the AWS Marketplace link for the AMI first and click
the "Accept" link 

    OptInRequired => In order to use this AWS Marketplace product you need to accept terms and subscribe.
    To do so please visit http://aws.amazon.com/marketplace/pp?sku=cjsrmewvppzcgw06k8yab9o6s 


## Logging into the VM (OVA or AMI)

Log in using either username/ password, or the keys that Vagrant (or yourself) baked in.


## Running Experiments

Do stuff. Check out [experiments](IS2016-Experiments.md).


## Ideas

It should not be hard to adapt this to other uses, i.e. install other toolkits, run it
on other providers, or install a scheduler in the VM to really use this as an ad-hoc cluster.
You can also make it work with spot instances (rather than on-demand), which can be quite
a bit cheaper.


## Troubleshooting

The documentation at the Speech Recognition Virtual Kitchen (<https://github.com/srvk>)
may be helpful, in particular the part about the Eesen Transcriber.


## License

See the attached [license](LICENSE), however be aware that some of the software installed with this Vagrantfile may have its own license conditions.


## Contact

Contact Florian Metze (<https://www.cs.cmu.edu/directory/fmetze>) or 
Eric Riebling (<https://www.cs.cmu.edu/directory/er1k>). 
