# Running the VM

You need to do the following steps in order to run the provided AMI:

- Find the AMI that you want to start by entering _ami-70433767_ into the [search box here](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:) (US East, N. Virginia region!)
- The VM should be found (if not, check with us if permissions have been set correctly), and you can run it on a _g2.2xlarge_ (_g2.8xlarge_ works as well) instance
- You should be able to leave all the "instance details" as is, but you may want to configure a VPC or other security group. You can also request spot instances, to save money (but risk termination).
- Storage should be configured correctly
- You can add (name) tags
- You should eventually get something that looks like this

![launch window](https://github.com/srvk/aws-sandbox/blob/master/2016-09-07%2012.59.06%20pm.png)

- After launching the AMI, a new instance should appear in your [list of instances](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:sort=instanceState)
- Once the state is running and the 2 checks have been completed successfully, click on the new instance, and select "Connect"
- You should get a popup window from which you can copy and paste a line that will allow you to connect to the instance (after some modifications)
- My line will typically look like this: __ssh -i ~/.ssh/ec2mykey.pem ec2-user@ec2-54-174-10-140.compute-1.amazonaws.com__ (I have to change the path to my key and the user name)
- Enjoy!

[Next, run some experiments.](IS2016-Experiments.md)

## Contact

Contact Florian Metze (<https://www.cs.cmu.edu/directory/fmetze>) or 
Eric Riebling (<https://www.cs.cmu.edu/directory/er1k>).
