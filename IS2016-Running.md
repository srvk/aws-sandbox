# Running the VM

You need to do the following steps in order to run the provided AMI:

- Find the AMI that you want to start by entering "ami-70433767" into the [search box here](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:) (US East, N. Virginia region!)
- The VM should be found (if not, check with us if permissions have been set correctly), and you can run it on a g2.2xlarge (g2.8xlarge works as well) instance
- You should be able to leave all the "instance details" as is, but you may want to configure a VPC or other security group. You can also request spot instances, to save money (but risk termination).
- Storage should be configured correctly
- You can add (name) tags
- You should eventually get something that looks like this
- 

[Next, run some experiments.](IS2016-Experiments.md)

## Contact

Contact Florian Metze (<https://www.cs.cmu.edu/directory/fmetze>) or 
Eric Riebling (<https://www.cs.cmu.edu/directory/er1k>).
