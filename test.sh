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

OUTPUT_DIR=/tmp/$RANDOM.$$
mkdir $OUTPUT_DIR

docker run \
  -v $PWD/fixture/gold_small.jsonl:/data/gold_small.jsonl:ro \
  -v $PWD/fixture/predictions_small.jsonl:/predictions/predictions_small.jsonl:ro \
  -v $OUTPUT_DIR:/output:rw \
  scifact-evaluator \
  python eval.py --labels_file /data/gold_small.jsonl --preds_file /predictions/predictions_small.jsonl --metrics_output_file /output/metrics.json --verbose

echo
echo ------------------------------
echo Metrics
echo ------------------------------
echo

EXPECTED=$(cat fixture/expected_metrics_small.json)
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
