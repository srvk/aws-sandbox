#!/bin/bash

sudo chmod 777 /media/ephemeral0 || echo storage already accessible

# Prepare experiments. We use kenlm instead of srilm
cd babel-exps/egs/asr/s5c/201-haitian-flp
ln -s spkList.dev spkList.dev2h
mkdir -p log

# Run the actual data preparation
./run-1-main.sh >& log/run.log

# Run the main training
./train-7-gpu.sh >& log/train-7-v0.log

# Run the test and scoring
./test-7-v1_x3.sh >& log/test-7-v0.log
