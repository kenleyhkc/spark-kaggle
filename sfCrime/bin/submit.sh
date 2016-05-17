#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
OUTPUT="classified.csv"
TMP_FILE="${OUTPUT}2"

sbt "project sfCrime" clean assembly

cd ${DIR}
rm -rf ${OUTPUT}
rm -rf ${TMP_FILE}

RESOURCES_PATH="src/main/resources/"
TRAIN_FILE="train.csv"
TRAIN_PATH="${RESOURCES_PATH}${TRAIN_FILE}"
TEST_FILE="test.csv"
TEST_PATH="${RESOURCES_PATH}${TEST_FILE}"

unzip ${TRAIN_PATH} -d ${RESOURCES_PATH}
unzip ${TEST_PATH} -d ${RESOURCES_PATH}

spark-submit \
  --class io.github.benfradet.SFCrime \
  --master local[2] \
  target/scala-2.11/sfCrime-assembly-1.0.jar \
  ${TRAIN_PATH} ${TEST_PATH} ${OUTPUT}

mv ${OUTPUT}/part-00000 ${TMP_FILE}
rm -rf ${OUTPUT}
mv ${TMP_FILE} ${OUTPUT}
rm -rf ${TRAIN_PATH} ${TEST_PATH}
