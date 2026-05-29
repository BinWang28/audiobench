#!/bin/bash

# =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =
# Example: evaluate SALMONN-7B on AudioBench.
#
# Prerequisite (one-time): download the model checkpoint into examples/.
#   cd examples
#   # needs Git LFS to fetch the large checkpoint files, e.g. `apt install git-lfs`
#   git clone https://huggingface.co/AudioLLMs/SALMONN_7B
#   cd ..
#
# Then run this script from the repo root:
#   bash examples/eval_SALMONN_7B.sh
#
# For model-as-judge metrics (e.g. llama3_70b_judge), first start the judge
# server in a separate process:  bash vllm_model_judge_llama_3_70b.sh
# =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =


# =  =  =  =  =  =  =  =  =  =  =  =  =  =  =
MODEL_NAME=SALMONN_7B
# =  =  =  =  =  =  =  =  =  =  =  =  =  =  =
GPU=0
BATCH_SIZE=1
OVERWRITE=False
NUMBER_OF_SAMPLES=-1   # -1 means use all test samples
# =  =  =  =  =  =  =  =  =  =  =  =  =  =  =


# Example task: English ASR on LibriSpeech (word error rate).
DATASET=librispeech_test_clean
METRICS=wer

bash eval.sh $DATASET $MODEL_NAME $GPU $BATCH_SIZE $OVERWRITE $METRICS $NUMBER_OF_SAMPLES
