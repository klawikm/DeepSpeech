# -*- coding: utf-8 -*-

from __future__ import absolute_import, division, print_function

# Make sure we can import stuff from util/
# This script needs to be run from the root of the DeepSpeech repository
import codecs
import sys
import os

sys.path.insert(1, os.path.join(sys.path[0], '..'))

import pandas

# from tensorflow.contrib.learn.python.learn.datasets import base
# from util.feeding import DataSets, DataSet

POLISH_CHARS2INDEX = {u'ą' : 27, u'ć' : 28, u'ę' : 29, u'ł' : 30, u'ń' : 31, u'ó' : 32, u'ś' : 33, u'ź' : 34, u'ż' : 35}

def _download_and_preprocess_data(data_dir, output_file):
    df = pandas.DataFrame(columns=["wav_filename", "wav_filesize", "transcript"])
    i = 0

    for file in os.listdir(data_dir):
        if file.endswith(".txt"):
            txt_path = os.path.join(data_dir, file)
            wav_path = txt_path.replace(".txt", ".wav")
            print(txt_path)

            with codecs.open(txt_path, "r", "utf-8") as fin:
                transcript = ' '.join(fin.read().strip().lower().split(' ')).replace('.', '')

                # validate input sequence
                allCharactersFromPlAlphabet = True
                for xt in transcript:
                    if (xt != ' ' and
                    xt not in POLISH_CHARS2INDEX and
                    not ord('a') <= ord(xt) <= ord('z')):
                        print("Skipping file %s because it contains character that does not belong to PL alphabet" % txt_path)
                        allCharactersFromPlAlphabet = False
                        break
                
                if not allCharactersFromPlAlphabet:
                    continue

            df.loc[i] = [os.path.abspath(wav_path), os.path.getsize(wav_path), transcript]
            i = i + 1
    df.to_csv(os.path.join(data_dir, output_file), index=False, encoding="utf-8")

if __name__ == "__main__":
    _download_and_preprocess_data(sys.argv[1], sys.argv[2])
