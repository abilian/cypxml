#!/bin/bash
NAME="cypxml"
HERE=$(pwd)
BUILD=../build

echo "======== bench small file ========"
python py_xmlwitch_test_small.py
cd ${BUILD}
python -c "from ${NAME} import test_perf_small as t ; t.main()"
cd ${HERE}
