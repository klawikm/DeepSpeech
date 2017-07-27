#!/bin/sh
set -xe
if [ ! -f DeepSpeech.py ]; then
    echo "Please make sure you run this from DeepSpeech's top level directory."
    exit 1
fi;

if [ ! -f "data/polish/polish.csv" ]; then
    echo "Downloading and preprocessing Polish example data, saving in ./data/polish."
    python -u bin/import_polish.py ./data/polish polish
fi;

python -u DeepSpeech.py \
  --train_files data/polish/polish_train.csv \
  --dev_files data/polish/polish_dev.csv \
  --test_files data/polish/polish_test.csv \
  --train_batch_size 1 \
  --dev_batch_size 1 \
  --test_batch_size 1 \
  --n_hidden 494 \
  --epoch 50 \
  --checkpoint_dir "~/DeepSpeechPolish" \
  "$@"
