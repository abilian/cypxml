#!/bin/bash
NAME="cypxml"
HERE=$(pwd)
BUILD=../build

echo "======== bench very big file ========"
python py_xmlwitch_very_big.py
cd ${BUILD}
python -c "from ${NAME} import test_perf_very_big as t ; t.t1()"
python -c "from ${NAME} import test_perf_very_big as t ; t.t2()"
python -c "from ${NAME} import test_perf_very_big as t ; t.t3()"
python -c "from ${NAME} import test_perf_very_big as t ; t.t4()"
python -c "from ${NAME} import test_perf_very_big as t ; t.t5()"
python -c "from ${NAME} import test_perf_very_big as t ; t.t6()"
python -c "from ${NAME} import test_perf_very_big as t ; t.t7()"
cd ${HERE}
