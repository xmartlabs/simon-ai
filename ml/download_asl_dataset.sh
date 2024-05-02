#!/bin/bash

# To download the dataset go to https://www.kaggle.com/datasets/grassknoted/asl-alphabet/download?datasetVersionNumber=1. Kaggles requires a logged in account
# in order to download it, so it's easier to download it manually. Then move archive.zip to /ml root folder and run this script


# constants
DIR=datasets/asl_alphabet_train/

mkdir -p $DIR
unzip archive.zip
mv asl_alphabet_train/asl_alphabet_train/L $DIR
mv asl_alphabet_train/asl_alphabet_train/O $DIR
mv asl_alphabet_train/asl_alphabet_train/K $DIR
mv asl_alphabet_train/asl_alphabet_train/I $DIR

# Clean up
rm archive.zip
rm -rf asl_alphabet_train
rm -rf asl_alphabet_test