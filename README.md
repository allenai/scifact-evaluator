# SciFact Evaluator

This repository contains code to evaluate submissions to the [SciFact](https://arxiv.org/abs/2004.14974) leaderboard, hosted at https://leaderboard.allenai.org. SciFact data and modeling code can be found at https://github.com/allenai/scifact. Description of files and directories follow.

- `evaluator/`: Contains evaluation code and environment.
  - `eval.py`: Evaluation script to be invoked by leaderboard.
  - `Dockerfile`: Specifies Docker env to be used when running `eval.py`.
- `fixture/`: Contains test fixtures.
  - `predictions_dummy.jsonl`: "Dummy" prediction file for all 300 (hidden) test instances that can be submitted to the leaderboard as a test. This submission should not be publicly displayed on the leaderboard.
  - `expected_metrics_dummy.json`: Metrics for `predictions_dummy.jsonl`
  - `gold_small.jsonl`: Gold labels for first 10 dev set instances.
  - `predictions_small.jsonl`: VeriSci predictions on the first 10 dev set instances. To be used as a test to confirm correctness of the evaluation code.
  - `expected_metrics_small.json`: Expected results of running `python evaluator/eval.py`, using `gold_small.jsonl` as the `labels_file` and `predictions_small.jsonl` as the `preds_file`.
- `test.sh`: Test that checks the correctness of the evaluator on `predictions_small.jsonl`.
