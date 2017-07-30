#!/bin/sh
set -xe
if [ ! -f DeepSpeech.py ]; then
    echo "Please make sure you run this from DeepSpeech's top level directory."
    exit 1
fi;

if [ ! -f "data/polish/polish_train.csv" ]; then
    echo "Downloading and preprocessing Polish example data, saving in ./data/polish."
    python -u bin/import_polish.py ./data/polish polish_train
fi;

python -u DeepSpeech.py \
  --train_files data/polish/polish_train.csv \
  --dev_files data/polish/polish_dev.csv \
  --test_files data/polish/polish_test.csv \
  --train_batch_size 20 \
  --dev_batch_size 10 \
  --test_batch_size 10 \
  --n_hidden 494 \
  --epoch 2000 \
  --display_step 10 \
  --validation_step 10 \
  --dropout_rate 0.30 \
  --default_stddev 0.046875 \
  --learning_rate 0.0001 \
  --checkpoint_dir "~/DeepSpeechPolish" \
  "$@"
