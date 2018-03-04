#!/usr/bin/env bash

set -e

source activate litex

SOC_FILES=$(find litex/boards/targets -name \*.py | grep -v sim | grep -v "__")

COUNT=4

for SOC_FILE in $SOC_FILES; do
	SOC=$(echo $SOC_FILE | sed -e's/\.py$//' -e's-/-.-g')
	TARGET=$(echo $SOC | sed -e's/.*\.//')

	travis_fold start "$SOC.1"
	travis_time_start
	echo "Building $TARGET ($SOC)"
	echo "-------------------------------------------------------------------"
	python -m $SOC --no-compile-gateware
	echo "-------------------------------------------------------------------"
	travis_time_finish
	travis_fold end "$SOC.1"
	travis_fold start "$SOC.2"
	echo "Output of building $SOC"
	echo "-------------------------------------------------------------------"
	find soc_*$TARGET* | sort
	echo "-------------------------------------------------------------------"
	travis_fold end "$SOC.2"
done
