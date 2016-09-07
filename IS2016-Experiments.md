# Experimenting with the VM

You can do the following experiments in the VM:

- After logging in, you should be greeted with a terminal window that looks like this:
  
  Florians-MBP:aws-sandbox metze$ ssh -i ~/.ssh/ec2fmetze.pem ec2-user@ec2-54-80-179-89.compute-1.amazonaws.com
  Last login: Wed Sep  7 16:24:45 2016 from florians-mbp.wv.cc.cmu.edu
  
         __|  __|_  )
         _|  (     /   Amazon Linux AMI
        ___|\___|___|
  
  https://aws.amazon.com/amazon-linux-ami/2016.03-release-notes/
  [ec2-user@ip-10-41-184-80 ~]$ 
  
- Let's try a command (and you want to do this command the first time you login to the VM):

  sudo chmod 777 /media/ephemeral0

- Now let's change into our experiment directory

  cd babel-exps/egs/asr/s5c/201-haitian-flp

- And let's run our experiments:

  ./run-1-main.sh >& log/my-run.log
  ./train-7-gpu.sh >& log/my-train.log
  ./test-7-v1_x3.sh >& log/my-test.log

- The three commands will do the following:
  - _run-1-main.sh_ will run the pre-processing of the data
  - _train-7-gpu.sh_ will run the actual DNN training
  - _test-7-v1_x3.sh_ will test the acoustic model


[Back to the main README.](README.md)

## Contact

Contact Florian Metze (<https://www.cs.cmu.edu/directory/fmetze>) or 
Eric Riebling (<https://www.cs.cmu.edu/directory/er1k>).
