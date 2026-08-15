<p align="center">
  <img src="assets/logo.png" alt="Prometheus-Logo" style="width: 30%; display: block; margin: auto;">
</p>

<h1 align="center">🔥 AudioBench 🔥</h1>


<p align="center">
  <a href="https://arxiv.org/abs/2406.16020"><img src="https://img.shields.io/badge/arXiv-2406.16020-b31b1b.svg" alt="arXiv"></a>
  <a href="https://huggingface.co/AudioLLMs"><img src="https://img.shields.io/badge/Hugging%20Face-Organization-ff9d00" alt="Hugging Face Organization"></a>
  <a href="https://huggingface.co/spaces/AudioLLMs/AudioBench-Leaderboard"><img src="https://img.shields.io/badge/AudioBench-Leaderboard-g41b1b.svg" alt="License"></a>
</p>

<p align="center">
  ⚡ A repository for evaluating AudioLLMs in various tasks 🚀 ⚡ <br>
  ⚡ AudioBench: A Universal Benchmark for Audio Large Language Models 🚀 ⚡ <br>
    <a href="https://huggingface.co/spaces/AudioLLMs/AudioBench-Leaderboard-Extend" 
     target="_blank" 
     style="text-decoration: none; color: #0078d7; font-weight: bold; font-size: 18px;">
     🌟 Come to View Our Live Leaderboard on Huggingface Space 🌟
  </a>
</p>

🏠 [AudioBench Leaderboard](https://huggingface.co/spaces/AudioLLMs/AudioBench-Leaderboard-Extend) | 🤗 [Huggingface Datasets](https://huggingface.co/AudioLLMs) | 🤗 [AudioLLM Paper Collection](https://github.com/AudioLLMs/Awesome-Audio-LLM) ![GitHub Repo stars](https://img.shields.io/github/stars/AudioLLMs/Awesome-Audio-LLM?style=social)

AudioBench is a universal benchmark for evaluating audio large language models (AudioLLMs) on speech, audio-scene, and voice understanding tasks across 50+ datasets. New to the codebase? See [ARCHITECTURE.md](./ARCHITECTURE.md) for how the pieces fit together.

## Contents
- [🔧 Installation](#installation)
- [⏩ Quick Start](#quick-start)
- [📊 Supported Datasets](#supported-datasets)
- [🤖 Supported Models](#supported-models)
- [➕ Add Your Own Dataset / Model](#add-your-own)
- [🏆 Leaderboard & Users](#leaderboard)
- [📝 Change Log](#change-log)
- [📖 Citation](#citation)
- [✅ To-Do List](#to-do)
- [🙌 Contributors](#contributors)


<a id="installation"></a>
## 🔧 Installation

Installation with pip:
```shell
pip install -r requirements.txt
```


<a id="quick-start"></a>
## ⏩ Quick Start

For model-as-judge evaluation, we serve the judgement model as a service via `vllm` on port `5000`.

The example is hosting a `Llama-3-70B-Instruct` model and running the cascade `Whisper + Llama-3` model.
```shell
# Step 1:
# Server the judgement model using VLLM framework (my example is using int4 quantized version)
# This requires with 1 * 80GB GPU
bash vllm_model_judge_llama_3_70b.sh

# Step 2:
# We perform model inference and obtain the evaluation results with the second GPU
GPU=2
BATCH_SIZE=1
OVERWRITE=True
NUMBER_OF_SAMPLES=-1 # indicate all test samples if number_of_samples=-1

MODEL_NAME=Qwen2-Audio-7B-Instruct

DATASET=cn_college_listen_mcq_test
METRICS=llama3_70b_judge

bash eval.sh $DATASET $MODEL_NAME $GPU $BATCH_SIZE $OVERWRITE $METRICS $NUMBER_OF_SAMPLES
```

To evaluate on a different dataset, just replace the `DATASET` and `METRIC` names (see the full list below):
```
DATASET=librispeech_test_clean
METRIC=wer
```


<a id="supported-datasets"></a>
## 📊 Supported Datasets

AudioBench supports 50+ datasets. Full names, metrics, and usage are in
[examples/supported_datasets.md](./examples/supported_datasets.md).

<details>
<summary><b>Full dataset list</b> (click to expand)</summary>

- [x] [librispeech_test_clean](./examples/supported_datasets.md), ASR, English, Metric: `wer`
- [x] [librispeech_test_other](./examples/supported_datasets.md), ASR, English, Metric: `wer`
- [x] [common_voice_15_en_test](./examples/supported_datasets.md), ASR, English, Metric: `wer`
- [x] [peoples_speech_test](./examples/supported_datasets.md), ASR, English, Metric: `wer`
- [x] [gigaspeech_test](./examples/supported_datasets.md), ASR, English, Metric: `wer`
- [x] [tedlium3_test](./examples/supported_datasets.md), ASR, English, Metric: `wer`
- [x] [tedlium3_long_form_test](./examples/supported_datasets.md), ASR, English, Long recording, Metric: `wer`
- [x] [earnings21_test](./examples/supported_datasets.md), ASR, English, Long recording, Metric: `wer`
- [x] [earnings22_test](./examples/supported_datasets.md), ASR, English, Long recording, Metric: `wer`
- [x] [aishell_asr_zh_test](./examples/supported_datasets.md), ASR, Chinese, Metric: `wer`
- [x] [covost2_en_id_test](./examples/supported_datasets.md), Speech Translation, English-Indonesian, Metric: `bleu`
- [x] [covost2_en_zh_test](./examples/supported_datasets.md), Speech Translation, English-Chinese, Metric: `bleu`
- [x] [covost2_en_ta_test](./examples/supported_datasets.md), Speech Translation, English-Tamil, Metric: `bleu`
- [x] [covost2_id_en_test](./examples/supported_datasets.md), Speech Translation, Indonesian-English, Metric: `bleu`
- [x] [covost2_zh_en_test](./examples/supported_datasets.md), Speech Translation, Chinese-English, Metric: `bleu`
- [x] [covost2_ta_en_test](./examples/supported_datasets.md), Speech Translation, Tamil-English, Metric: `bleu`
- [x] [cn_college_listen_mcq_test](./examples/supported_datasets.md), Speech Question Answering, Multiple Choice, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [slue_p2_sqa5_test](./examples/supported_datasets.md), Speech Question Answering, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [dream_tts_mcq_test](./examples/supported_datasets.md), Speech Question Answering, Multiple Choice, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [public_sg_speech_qa_test](./examples/supported_datasets.md), Speech Question Answering, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [spoken_squad_test](./examples/supported_datasets.md), Speech Question Answering, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [openhermes_audio_test](./examples/supported_datasets.md), Speech Instruction, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [alpaca_audio_test](./examples/supported_datasets.md), Speech Instruction, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [spoken-mqa_short_digit](./examples/supported_datasets.md), Speech Instruction, Metric: `acc`
- [x] [spoken-mqa_long_digit](./examples/supported_datasets.md), Speech Instruction, Metric: `acc`
- [x] [spoken-mqa_single_step_reasoning](./examples/supported_datasets.md), Speech Instruction, Metric: `acc`
- [x] [spoken-mqa_multi_step_reasoning](./examples/supported_datasets.md), Speech Instruction, Metric: `acc`
- [x] [audiollm_instructionfollowing](./IFEval-Audio/README.md), Instruction Following ([IFEval-Audio](./IFEval-Audio/README.md)), Metric: `llama3_70b_judge_combined`
- [x] [clotho_aqa_test](./examples/supported_datasets.md), Speech Question Answering, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [wavcaps_qa_test](./examples/supported_datasets.md), Audio Scene Question Answering, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [audiocaps_qa_test](./examples/supported_datasets.md), Audio Scene Question Answering, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [wavcaps_test](./examples/supported_datasets.md), Audio Scene Question Answering, Metric: `llama3_70b_judge`, `meteor`, `gpt4o_judge`
- [x] [audiocaps_test](./examples/supported_datasets.md), Audio Scene Question Answering, Metric: `llama3_70b_judge`, `meteor`, `gpt4o_judge`
- [x] [iemocap_emotion_test](./examples/supported_datasets.md), Emotion Recognition, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [meld_sentiment_test](./examples/supported_datasets.md), Emotion Recognition, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [meld_emotion_test](./examples/supported_datasets.md), Emotion Recognition, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [voxceleb_accent_test](./examples/supported_datasets.md), Accent Recognition, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [voxceleb_gender_test](./examples/supported_datasets.md), Gender Recognition, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [iemocap_gender_test](./examples/supported_datasets.md), Gender Recognition, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [muchomusic_test](./examples/supported_datasets.md), Music Understanding, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_part1_asr_test](./examples/supported_datasets.md), Singlish ASR, Metric: `wer`
- [x] [imda_part2_asr_test](./examples/supported_datasets.md), Singlish ASR, Metric: `wer`
- [x] [imda_part3_30s_asr_test](./examples/supported_datasets.md), Singlish ASR, Metric: `wer`
- [x] [imda_part4_30s_asr_test](./examples/supported_datasets.md), Singlish ASR, Metric: `wer`
- [x] [imda_part5_30s_asr_test](./examples/supported_datasets.md), Singlish ASR, Metric: `wer`
- [x] [imda_part6_30s_asr_test](./examples/supported_datasets.md), Singlish ASR, Metric: `wer`
- [x] [imda_part3_30s_sqa_human_test](./examples/supported_datasets.md), Singlish Speech Question Answering, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_part4_30s_sqa_human_test](./examples/supported_datasets.md), Singlish Speech Question Answering, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_part5_30s_sqa_human_test](./examples/supported_datasets.md), Singlish Speech Question Answering, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_part6_30s_sqa_human_test](./examples/supported_datasets.md), Singlish Speech Question Answering, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_part3_30s_ds_human_test](./examples/supported_datasets.md), Singlish Speech Summarization, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_part4_30s_ds_human_test](./examples/supported_datasets.md), Singlish Speech Summarization, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_part5_30s_ds_human_test](./examples/supported_datasets.md), Singlish Speech Summarization, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_part6_30s_ds_human_test](./examples/supported_datasets.md), Singlish Speech Summarization, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_ar_sentence](./examples/supported_datasets.md), Singlish, Accent Recognition, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_ar_dialogue](./examples/supported_datasets.md), Singlish, Accent Recognition, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_gr_sentence](./examples/supported_datasets.md), Singlish, Gender Recognition, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [imda_gr_dialogue](./examples/supported_datasets.md), Singlish, Gender Recognition, Metric: `llama3_70b_judge`, `gpt4o_judge`
- [x] [seame_dev_man](./examples/supported_datasets.md), English-Chinese Code-Switching, Metric: `wer`
- [x] [seame_dev_sge](./examples/supported_datasets.md), English-Chinese Code-Switching, Metric: `wer`
- [x] [mmau_mini](./examples/supported_datasets.md), Audio Understanding and Reasoning, Multiple Choice Questions, Metric: `llama3_70b_judge`, `string_match`, `gpt4o_judge`
- [x] [gigaspeech2_thai](./examples/supported_datasets.md), ASR for Thai language, Metric: `wer`
- [x] [gigaspeech2_indo](./examples/supported_datasets.md), ASR for Indonesian language, Metric: `wer`
- [x] [gigaspeech2_viet](./examples/supported_datasets.md), ASR for Vietnamese language, Metric: `wer`
- [ ] [ASCEND](./examples/supported_datasets.md), English-Chinese Code-Switching, Metric: `wer`
- [ ] [fleurs] speech translation
- [ ] [AIR-Bench] airbench tasks

</details>


<a id="supported-models"></a>
## 🤖 Supported Models

See [examples/adding_new_model.md](./examples/adding_new_model.md) for setup details.

- [x] [cascade_whisper_large_v3_llama_3_8b_instruct](./examples/adding_new_model.md)
- [x] [cascade_whisper_large_v2_gemma2_9b_cpt_sea_lionv3_instruct](./examples/adding_new_model.md)
- [x] [MERaLiON-AudioLLM-Whisper-SEA-LION](./examples/adding_new_model.md)
- [x] [Qwen-Audio-Chat](./examples/adding_new_model.md)
- [x] [Qwen2-Audio-7B-Instruct](./examples/adding_new_model.md)
- [x] [SALMONN_7B](./examples/adding_new_model.md): need extra git clone.
- [ ] [WavLLM_fairseq](./examples/adding_new_model.md): deprecated — inference setup is too involved; the loader is kept for reference.
- [x] [whisper_large_v3](./examples/adding_new_model.md)
- [x] [whisper_large_v2](./examples/adding_new_model.md)
- [x] [gemini-1.5-flash](./examples/adding_new_model.md): key needed
- [x] [gemini-2-flash](./examples/adding_new_model.md): key needed
- [x] [gpt-4o-audio](./examples/adding_new_model.md): key needed
- [x] [phi_4_multimodal_instruct](./examples/adding_new_model.md)
- [x] [seallms_audio_7b](https://huggingface.co/SeaLLMs/SeaLLMs-Audio-7B)
- [ ] [ultravox](./examples/adding_new_model.md) https://huggingface.co/fixie-ai/ultravox-v0_5-llama-3_1-8b / https://www.ultravox.ai/
- [ ] [llama3_s](./examples/adding_new_model.md) 
- [ ] [audio-flamingo-2](./examples/adding_new_model.md)
- [ ] [GLM4-Voice]
- [ ] [Mini-Omni]
- [ ] [SLAM-Omni]
- [ ] [https://huggingface.co/scb10x/llama3.1-typhoon2-audio-8b-instruct]
- [ ] [https://huggingface.co/WillHeld/DiVA-llama-3-v0-8b]


<a id="add-your-own"></a>
## ➕ Add Your Own Dataset / Model

**Your own dataset** — two steps:
1. Make a copy of one of the customized dataset loaders. Example: [cn_college_listen_mcq_test](src/dataset_src/cn_college_listen_mcq_test.py). Customize it for your own dataset.
2. Add a new entry in [dataset.py](src/dataset.py).

**Your own model** — as long as the model can do inference, you can load it and generate responses. See [adding_new_model](./examples/adding_new_model.md).

For an overview of how datasets, models, and metrics fit together, see [ARCHITECTURE.md](./ARCHITECTURE.md).


<a id="leaderboard"></a>
## 🏆 Leaderboard & Users

🌟 [View the live AudioBench Leaderboard on Hugging Face Spaces](https://huggingface.co/spaces/AudioLLMs/AudioBench-Leaderboard-Extend)

**To submit your model to the leaderboard**, email: `bwang28c@gmail.com`

**Researchers, companies or groups that are using AudioBench:**
- [Llama3-S: When Llama Learns to Listen](https://homebrew.ltd/blog/llama3-just-got-ears)
- [llms-eval](https://github.com/EvolvingLMMs-Lab/lmms-eval/blob/main/docs/lmms-eval-0.3.md)
- More to come...


<a id="change-log"></a>
## 📝 Change Log

<details>
<summary>Expand change log</summary>

* *Mar 2025*: Supported [phi_4_multimodal_instruct](https://huggingface.co/microsoft/Phi-4-multimodal-instruct) model, [gigaspeech 2](https://arxiv.org/abs/2406.11546) evaluation (Thai, Vietnamese and Indonesian).
* *Mar 2025*: Support [MMAU](https://sakshi113.github.io/mmau_homepage/) testset. Multiple-choice questions for speech, audio and music understanding!
* *Mar 2025*: AudioBench now supports over 50 datasets!!
* *Mar 2025*: Support SEAME testsets (dev). It is a code-switching dataset for Chinese and Singapore accented English.
* *JAN 2025*: AudioBench paper is accepted to NAACL 2025 Main Conference.
* *JAN 2025*: Support 10+ [MNSC - Singlish Understanding](https://huggingface.co/datasets/MERaLiON/Multitask-National-Speech-Corpus-v1) datasets, the results are updated on leaderboard.
* *DEC 2024*: Support more (35) datasets / more Models (2 cascade and 3 fusion models).
* *SEP 2024*: Add [MuChoMusic](https://arxiv.org/abs/2408.01337) dataset for music evaluation (multiple choice questions).
* *AUG 2024*: Support a 6 speech translation datasets. Update the evaluation script for several MCQ evaluation.
* *AUG 2024*: Leaderboard is live. Check it out [here](https://huggingface.co/spaces/AudioLLMs/AudioBench-Leaderboard).
* *JUL 2024*: We are working hard on the leaderboard and speech translation dataset. Stay tuned!
* *JUL 2024*: Support all INITIAL 26 datasets listed in AudioBench manuscript.

</details>

[![Star History Chart](https://star-history.dera.page/svg?repos=AudioLLMs/AudioBench&type=Date)](https://star-history.dera.page/#AudioLLMs/AudioBench&Date)


<a id="citation"></a>
## 📖 Citation
If you find our work useful, please consider citing our paper!
```bibtex
@article{wang2024audiobench,
  title={AudioBench: A Universal Benchmark for Audio Large Language Models},
  author={Wang, Bin and Zou, Xunlong and Lin, Geyu and Sun, Shuo and Liu, Zhuohan and Zhang, Wenyu and Liu, Zhengyuan and Aw, AiTi and Chen, Nancy F},
  journal={NAACL},
  year={2025}
}
```


<a id="to-do"></a>
## ✅ To-Do List
- [ ] Features
  - [ ] Evaluation with audio/speech generation
  - [ ] Evaluation with multiround chatbot
  - [ ] Also support other model-as-judge and report the results
  - [ ] Update AI-SHELL from WER to CER
- [x] Bugs
  - [x] Threads of model-as-judge
  - [x] Post-processing script for IMDA PART4 which contains code-switching in 4 languages.


<a id="contributors"></a>
## 🙌 Contributors
- Xue Cong Tey (MMAU-mini Dataset)
