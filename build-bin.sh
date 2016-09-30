#!/bin/bash
lb clean --binary
lb build 2>&1 | tee build.log
