#!/bin/bash
NAME="cypxml"

echo "======== bench ========"
python py_xmlwitch_test_big.py
cd build
python -c "from ${NAME} import test_perf_big as t ; t.main()"
cd ..
