#!/bin/bash

set -e

echo ------------------------------
echo Building evaluator
echo ------------------------------
echo

cd evaluator
docker build -t scifact-evaluator .
cd ..

echo
echo ------------------------------
echo Running evaluator
echo ------------------------------
echo

OUTPUT_DIR=$(mktemp -d)

docker run \
  -v $PWD/fixture/gold_small.jsonl:/data/gold_small.jsonl:ro \
  -v $PWD/fixture/predictions_small.jsonl:/predictions/predictions_small.jsonl:ro \
  -v $OUTPUT_DIR:/output:rw \
  scifact-evaluator \
  python eval.py --labels_file /data/gold_small.jsonl --preds_file /predictions/predictions_small.jsonl --metrics_output_file /output/metrics.json

echo
echo ------------------------------
echo Metrics
echo ------------------------------
echo


# TODO(dw) how do I get this to point to the expected metrics file? It's at
# fixture/expected_metrics.json.
EXPECTED='{"F1": 0.6666666666666666, "EM": 0.6666666666666666, "C": 0.5}'
ACTUAL=$(cat $OUTPUT_DIR/metrics.json)

echo Metrics obtained in file $OUTPUT_DIR/metrics.json:
echo
echo $ACTUAL
echo

if [ "$ACTUAL" == "$EXPECTED" ]; then
    echo Metrics match expected values!
    echo
    echo Test passed.
else
    echo Metrics DO NOT match expected values! Expected:
    echo
    echo $EXPECTED
    echo
    echo Something is wrong, test failed.
    exit 1
fi
