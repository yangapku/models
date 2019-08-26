#!/bin/bash

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

if [ ! -d log ]; then
mkdir log
else
rm -r log/*
fi

if [ ! -d output ]; then
mkdir output
else
rm -r output/*
fi

export FLAGS_cudnn_deterministic=true
export FLAGS_cpu_deterministic=true

PWD_DIR=`pwd`
DATA=../data/
BERT_DIR=cased_L-24_H-1024_A-16
CPT_EMBEDDING_PATH=../retrieve_concepts/KB_embeddings/wn_concept2vec.txt
CKPT_DIR=$1

python3 src/run_record.py \
  --batch_size 6 \
  --do_train false \
  --do_predict true \
  --use_ema false \
  --do_lower_case false \
  --init_pretraining_params $BERT_DIR/params \
  --init_checkpoint $CKPT_DIR \
  --train_file $DATA/ReCoRD/train.json \
  --predict_file $DATA/ReCoRD/dev.json \
  --vocab_path $BERT_DIR/vocab.txt \
  --bert_config_path $BERT_DIR/bert_config.json \
  --freeze false \
  --max_seq_len 384 \
  --doc_stride 128 \
  --concept_embedding_path $CPT_EMBEDDING_PATH \
  --use_wordnet true \
  --random_seed 45 \
  --checkpoints output/ 1>$PWD_DIR/log/train.log 2>&1