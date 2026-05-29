# IFEval-Audio

> Part of the [AudioBench](../README.md) benchmark suite. See the main README for installation, the full dataset list, and how to run evaluations.

## Overview
IFEval-Audio is a dataset to evaluate instruction-following in audio-based LLMs, with 280 audio-instruction-answer triples across six dimensions: Content, Capitalization, Symbol, List Structure, Length, and Format.

## Dataset Structure
- **Audio Input**: From Spoken SQUAD, TED-LIUM 3, Muchomusic, etc.
- **Text Instruction**: Specifies one dimension (e.g., "Use JSON format").
- **Expected Answer**: Reference output.
- **Dimensions**: Content, Capitalization, Symbol, List Structure, Length, Format.
- **Distribution**: 240 speech triples (40/dimension), 40 music/environmental triples.

## Dataset
The dataset is hosted on Hugging Face: [`YichenG170/AudioLLMInstructionFollowing`](https://huggingface.co/datasets/YichenG170/AudioLLMInstructionFollowing)
(you may need to log in and accept the access conditions). It is loaded automatically by the
evaluation code — no manual download is required.

## How to Run
IFEval-Audio is integrated into AudioBench as the dataset `audiollm_instructionfollowing`
with the metric `llama3_70b_judge_combined`. From the repo root:

```shell
# Step 1 (separate process): serve the Llama-3-70B judge used to score correctness.
bash vllm_model_judge_llama_3_70b.sh

# Step 2: run inference + evaluation for your model.
GPU=0
BATCH_SIZE=1
OVERWRITE=True
NUMBER_OF_SAMPLES=-1               # -1 = all 280 triples

MODEL_NAME=Qwen2-Audio-7B-Instruct # any supported model
DATASET=audiollm_instructionfollowing
METRICS=llama3_70b_judge_combined

bash eval.sh $DATASET $MODEL_NAME $GPU $BATCH_SIZE $OVERWRITE $METRICS $NUMBER_OF_SAMPLES
```

The judge reports the three metrics below, broken down by the six dimensions.

## Evaluation Metrics
IFR: Format adherence score (0/1).
SCR: Semantic correctness score (0/1).
OSR: Triples with IFR=1 and SCR=1.

## Citation
```bibtex
@article{gao2025ifevalaudio,
  title={IFEval-Audio: Benchmarking Instruction-Following Capability in Audio-based Large Language Models},
  author={Gao, Yiming and Wang, Bin and Wei, Chengwei and Sun, Shuo and Aw, AiTi},
  journal={arXiv preprint arXiv:2505.16774},
  year={2025}
}
```
