#!/usr/bin/env bash

find . -type f -not -path "./venv/*" -name "*.box"
find . -type f -not -path "./venv/*" -name "*.box" | xargs rm
find . -type f -not -path "./venv/*" -name "*.iso"
find . -type f -not -path "./venv/*" -name "*.iso" | xargs rm
find . -type d -not -path "./venv/*" -name "output-*"
find . -type d -not -path "./venv/*" -name "output-*" | xargs rm -rf
