#!/bin/bash
NAME="cypxml"
HERE=$(pwd)
BUILD=../build

echo "======== bench big file ========"
python py_xmlwitch_test_big.py
cd ${BUILD}
python -c "from ${NAME} import test_perf_big as t ; t.main()"
cd ${HERE}
