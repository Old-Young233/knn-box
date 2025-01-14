:<<! 
[script description]: build a datastore and then prune, using greedy merge method and PCA 
[dataset]: multi domain DE-EN dataset
[base model]: WMT19 DE-EN
!

PROJECT_PATH=$( cd -- "$( dirname -- "$ BASH_SOURCE[0]}" )" &> /dev/null && pwd )/../..
BASE_MODEL=$PROJECT_PATH/pretrain-models/wmt19.de-en/wmt19.de-en.ffn8192.pt
DATA_PATH=$PROJECT_PATH/data-bin/it
PCA_DIM=256
MERGE_NEIGHBORS_N=2

CUDA_VISIBLE_DEVICES=0 python $PROJECT_PATH/knnbox-scripts/common/validate.py $DATA_PATH \
--task translation \
--path $BASE_MODEL \
--model-overrides "{'eval_bleu': False, 'required_seq_len_multiple':1, 'load_alignments': False}" \
--dataset-impl mmap \
--valid-subset train \
--skip-invalid-size-inputs-valid-test \
--max-tokens 4096 \
--bpe fastbpe \
--user-dir $PROJECT_PATH/knnbox/models \
--arch greedy_merge_knn_mt@transformer_wmt19_de_en \
--knn-mode build_datastore \
--pca-dim $PCA_DIM \
--merge-neighbors-n $MERGE_NEIGHBORS_N \
--knn-datastore-path $PROJECT_PATH/datastore/greedy-merge/it_pca${PCA_DIM}_merge${MERGE_NEIGHBORS_N} \
