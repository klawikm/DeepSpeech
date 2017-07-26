#!/bin/sh
set -xe

python3 -u DeepSpeech.py \
  --notrain \
  --test_files data/polish_tesco/polish-tesco.csv \
  --train_files data/polish_tesco/polish-tesco.csv \
  --dev_files data/polish_tesco/polish-tesco.csv \
  --test_batch_size 5 \
  --n_hidden 494 \
  --epoch 50 \
  --checkpoint_dir "/home/michal/DeepSpeechPolish" \
  "$@"