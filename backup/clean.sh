#!/usr/bin/env bash

find ~/qsc_ws/ | grep cmake-build-debug >cmake-build-debug.txt
find ~/qsc_ws/ | grep .git >git.txt
