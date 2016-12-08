#!/bin/bash
day="$1"
header=""
if [ -f "day$day.h" ]; then
    header="-import-objc-header day$day.h"
fi

# -import-objc-header day5.h
cat extensions.swift day$1.swift | swift $header - "$(cat ../baboons-php7/input/day$1.txt)"
