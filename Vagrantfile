Vagrant.configure("2") do |config|

  config.vm.define "gpu" do |gpu|
    config.vm.provider "aws" do |aws, override|
      # NVIDIA AMI in N Virginia (https://aws.amazon.com/marketplace/ordering?productId=d3fbf14b-243d-46e0-916c-82a8bf6955b4&ref_=dtl_psb_continue&region=us-east-1)
      aws.ami = "ami-a41a3fb3"
      aws.instance_type="p2.xlarge"
      #aws.instance_type="g2.2xlarge"
      #aws.instance_type="g2.8xlarge"
      override.ssh.username = "ec2-user"

      # this can be used to add a disc to p2 instances (needs to be mounted manually for now)
      aws.block_device_mapping = [{
                                    'DeviceName' => '/dev/xvdb',
                                    'Ebs.VolumeSize' => 60,
                                    'Ebs.VolumeType' => 'gp2',
                                    'Ebs.DeleteOnTermination' => 'true' }]

      # try ami-34148f23
      # sudo add-apt-repository ppa:graphics-drivers/ppa
      # sudo apt update
      # sudo apt-get install nvidia-370-dev
      # sudo reboot
      # "apt-cache search nvidia"
    end
  end

  config.vm.define "gpubuntu" do |gpu|
    config.vm.provider "aws" do |aws, override|
      # Ubuntu 16.04 hvm:ebs-ssd AMI on which NVIDIA can be installed easily (https://cloud-images.ubuntu.com/locator/ec2/)
      aws.ami = "ami-e3c3b8f4"
      aws.instance_type="p2.xlarge"
      #aws.instance_type="g2.8xlarge"
      override.ssh.username = "ubuntu"

      # sudo add-apt-repository ppa:graphics-drivers/ppa
      # sudo apt update
      # sudo apt-get install nvidia-370-dev
      # sudo reboot
      # "apt-cache search nvidia"
      # sudo dpkg-reconfigure dash
    end
  end

  config.vm.define "macaudio" do |macaudio|
    config.vm.provider "virtualbox" do |vbox|    
      # force audio hardware (defaults to no soundcard) for OSX
      vbox.customize ["modifyvm", :id, '--audio', 'coreaudio', '--audiocontroller', 'hda']
    end
  end

  config.vm.define "default" do |cpu|
    config.vm.provider "aws" do |aws|
      # Non-GPU AMIs
      aws.ami = "ami-60b6c60a"
      aws.instance_type = "m3.large"
      # t2.micro would be better, but has some VPC problem
    end
    config.vm.provider "virtualbox" do |vbox|
      vbox.customize ["modifyvm", :id, '--audio', 'pulse', '--audiocontroller', 'ac97']
      # choices: hda sb16 ac97
    end
  end

  config.vm.provider "aws" do |aws, override|
    override.vm.box = "dummy"

    # it is best to set these environment variables in "secrets.sh"
    aws.access_key_id = ENV['AWS_KEY']
    aws.secret_access_key = ENV['AWS_SECRETKEY']
    # your AWS access keys
    aws.keypair_name = ENV['AWS_KEYPAIR']
    # something like "ec2user" (ssh key pair)
    override.ssh.private_key_path = ENV['AWS_PEM']
    # something like "~/.ssh/ec2.pem"

    aws.terminate_on_shutdown = "true"
    aws.region = "us-east-1"

    # Not sure which of these we want
    #aws.security_groups = [ "CMU Addresses", "default" ]
    aws.security_groups = ENV['AWS_SECGRPS'] # cannot use names here!
    aws.subnet_id = ENV['AWS_SUBNETID'] # vagrantVPC publicSubnet
    aws.associate_public_ip = true
    aws.elastic_ip = true

    # Relevant for Amazon Linux
    # This is so that 'sudo' does not require a TTY and can run immediately
    # Further it allows our multiple machines to talk to each other via ssh (and updates packages)
    # Create with "write-mime-multipart --output=user_data.txt boothook:text/cloud-boothook config"
    aws.user_data = File.read("user_data.txt")
    #aws.user_data = "#boothook\n!/bin/bash\nsed -i 's/Defaults    requiretty/# Defaults    requiretty/' /etc/sudoers"
    #aws.user_data = "#cloud-config\npackage_upgrade: true"
    
    # Scratch disc
#    aws.block_device_mapping = [{ 'DeviceName' => "/dev/sdb",
#                                  'VirtualName' => "scratch", 'Ebs.VolumeSize' => 240,
#                                  'Ebs.DeleteOnTermination' => true }]
    aws.block_device_mapping = [
      { 'DeviceName' => '/dev/sdb', 'VirtualName' => 'ephemeral0' },
      { 'DeviceName' => '/dev/sdc', 'VirtualName' => 'ephemeral1' } ]
    
    # Hostmanager (we probably want this)
    # https://github.com/smdahlen/vagrant-hostmanager
    
    aws.region_config "us-east-1" do |region|
      #region.spot_instance = true
      #region.spot_max_price = "0.5"
    end
    
    # this works around the error (ubuntu linux host):
    #   No host IP was given to the Vagrant core NFS helper. This is
    #   an internal error that should be reported as a bug.
    override.nfs.functional = false
  end

  config.vm.provider "virtualbox" do |vbox, override|
    override.vm.box = "ubuntu/trusty64"
    override.ssh.forward_x11 = true

    vbox.cpus = 2
    vbox.memory = 8192
  end

  # run final provisions
  # (1) install the main system-level software stack
  config.vm.provision "shell", path: "scripts/sw.sh"
  # (2) install network-related services (file systems)
  config.vm.provision "shell", path: "scripts/network.sh"
  # (3) some clean-up and stuff that we may need to do on reboot
  config.vm.provision "shell", inline: <<-SHELL
    if [[ `awk '{print $1; exit}' /etc/issue` =~ buntu ]]; then
      # Assume we are on Virtualbox (Ubuntu)
      mkdir -pm 777 /scratch
      #/vagrant/scripts/vbox-audio.sh

    else
      # Assume we are on AWS

      # This is needed for authorization in the case of a cluster (see startup.sh)
      curl -s http://169.254.169.254/latest/public-keys/0/openssh-key | sha512sum | cut -d " " -f1 | sudo tee /etc/munge/munge.key > /dev/null
      sudo mkdir -p /var/run/munge
      sudo munged -f

      # See https://wiki.archlinux.org/index.php/TORQUE
      #   populate /etc/hosts (add ip-... name, too)
      #   /etc/torque/server_name <- ip-... (server)

      # Let's get the scratch drive in place on /media/ephemeral0
      if [[ `lsblk` =~ xvdc ]]; then
        # we have two drives to make into a RAID
        umount /media/ephemeral0 || echo ephemeral0 not mounted
        mdadm --create --run --verbose /dev/md0 --level=0 --name=raid0 --raid-devices=2 /dev/xvdb /dev/xvdc
        mkfs.ext4 -L raid /dev/md0
        mount /dev/md0 /media/ephemeral0
      elseif [[ `lsblk` =~ xvdb && `lsblk -o MOUNTPOINT /dev/xvdb | wc -l` < 2 ]]; then
        # we have one drive that needs mounting
        umount /media/ephemeral0 || echo ephemeral0 not mounted
        mkfs.ext4 -L raid /dev/xvdb
        mount /dev/xvdb /media/ephemeral0
      else
        echo Only one block device detected, hopefully already mounted
      fi
      sudo chmod 777 /media/ephemeral0
    fi
  SHELL
  # (4) install user-level software 
  config.vm.provision "shell", path: "scripts/eesen.sh", privileged: false
  # (5) we could auto-run the experiments (but don't)
  #config.vm.provision "shell", path: "scripts/exps.sh"
end
