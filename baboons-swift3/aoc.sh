#!/bin/bash
day="$1"
cat extensions.swift day$1.swift | swift - "$(cat ../baboons-php7/input/day$1.txt)"
