# AudioBench Architecture

A short map of how the codebase fits together, so you can find your way around and
extend it without reading every file.

## Big picture

One evaluation run scores a single **(dataset, model, metric)** triple. `eval.sh` is the
thin shell wrapper; it calls the real entry point `src/main_evaluate.py`:

```
bash eval.sh $DATASET $MODEL_NAME $GPU $BATCH_SIZE $OVERWRITE $METRICS $NUMBER_OF_SAMPLES
        │
        └── python src/main_evaluate.py --dataset_name ... --model_name ... --metrics ...
```

The pipeline inside `main_evaluate.py`:

```
Dataset(dataset_name)                     model = Model(model_name)
  ├─ load_dataset()  → raw HF data          └─ load_model()  → weights / API client
  └─ data_format()   → dataset_processor
        │                                          │
        │   input_data = processor.prepare_model_input()
        │                                          │
        └────────────► model.generate(input) ──────┘
                              │
                  predictions cached to  log_for_all_models/<model>/<dataset>.json
                              │
        processor.compute_score(records, metrics)  →  <dataset>_<metric>_score.json
```

Two short-circuits keep reruns cheap:
- if the `_score.json` already exists and `overwrite=False`, the run is skipped entirely;
- if the prediction `.json` exists, inference is skipped and only scoring re-runs.

## Directory layout

| Path | Role |
|------|------|
| `src/main_evaluate.py` | Entry point / orchestrator (the **only** entry — invoked by `eval.sh`). |
| `src/model.py` | `Model` class. Dispatches a model name to its implementation via `MODEL_REGISTRY`. |
| `src/model_src/<module>.py` | One file per model. Exposes `<module>_model_loader` / `<module>_model_generation`. |
| `src/dataset.py` | `Dataset` class. Loads raw data and selects the matching processor. |
| `src/dataset_src/<name>.py` | One file per dataset. Prepares inputs, formats predictions, computes the score. |
| `src/dataset_src/eval_methods/` | Scoring backends: string match, and LLM-as-judge (Llama-3, GPT-4o, Prometheus2). |
| `src/dataset_src/prompts/`, `text_normalizer/`, `math_utils/` | Shared helpers used by processors. |
| `examples/` | `supported_datasets.md`, `supported_models.md`, and per-model launch scripts. |
| `leaderboard/` | Standalone Streamlit app that renders the public leaderboard (not part of eval). |
| `vllm_model_judge_llama_3_70b.sh` | Serves the Llama-3-70B judge used by `*_judge*` metrics. |

## The two contracts

**Model** (`model_src/<module>.py`) — two functions:
- `<module>_model_loader(self)` — set up `self.model` / processor / API client on the `Model` instance.
- `<module>_model_generation(self, input)` — return the prediction(s) for one input.

`model.py` resolves these by name through `MODEL_REGISTRY`, which maps the public model
name to its module. Modules are imported lazily, so a model's (often heavy) dependencies
are only loaded when that model is actually used.

**Dataset** (`dataset_src/<name>.py`) — a processor class with three methods:
- `prepare_model_input()` → list of model inputs (audio + instruction).
- `format_model_predictions(inputs, predictions)` → records with predictions attached.
- `compute_score(records, metrics)` → `{metric: value, ...}` (and optionally `details`).

Metrics fall into three families: exact/string match, reference metrics (WER, BLEU,
METEOR), and **model-as-judge** (`*_judge*`), which calls an LLM in `eval_methods/` —
the judge model must be served separately (see `vllm_model_judge_llama_3_70b.sh`).

## Adding things

- **New model:** add `model_src/<module>.py` with the two functions, then add one line to
  `MODEL_REGISTRY` in `src/model.py`. Document it in `examples/supported_models.md`.
- **New dataset:** add its source under `Dataset.load_dataset()`, add a processor under
  `dataset_src/`, wire it into `Dataset.data_format()`, and list it in
  `examples/supported_datasets.md`.
