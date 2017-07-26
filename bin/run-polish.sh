#!/bin/sh
set -xe
if [ ! -f DeepSpeech.py ]; then
    echo "Please make sure you run this from DeepSpeech's top level directory."
    exit 1
fi;

if [ ! -f "data/polish_tesco/polish-tesco.csv" ]; then
    echo "Downloading and preprocessing Polish-Tesco example data, saving in ./data/polish_tesco."
    python3 -u bin/import_polish.py ./data/polish_tesco
fi;

# checkpoint_dir=$(python -c 'from xdg import BaseDirectory as xdg; print(xdg.save_data_path("deepspeech/ldc93s1"))')

python3 -u DeepSpeech.py \
  --train_files data/polish_tesco/polish-tesco.csv \
  --dev_files data/polish_tesco/polish-tesco.csv \
  --test_files data/polish_tesco/polish-tesco.csv \
  --train_batch_size 1 \
  --dev_batch_size 1 \
  --test_batch_size 1 \
  --n_hidden 494 \
  --epoch 50 \
  --checkpoint_dir "/home/michal/DeepSpeechPolish" \
  "$@"