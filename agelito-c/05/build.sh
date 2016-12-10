#!/bin/sh

cd $(dirname "$0")

gcc -Wall md5.c day05.c
