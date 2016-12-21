#!/bin/bash

set -e

for x in */part?.php; do
    echo -n "$x: "
    php -f $x
done