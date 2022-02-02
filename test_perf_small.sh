#!/bin/bash
NAME="cypxml"

echo "======== bench ========"
python py_xmlwitch_test_small.py
cd build
python -c "from ${NAME} import test_perf_small as t ; t.main()"
cd ..
