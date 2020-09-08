#!/usr/bin/env bash

find . -type d -name "port"
find . -type d -name "port" | xargs rm -rf
find . -type d -not -path "./venv/*" -name "output-*"
find . -type d -not -path "./venv/*" -name "output-*" | xargs rm -rf
find . -type f -not -path "./venv/*" -name "*.box"
find . -type f -not -path "./venv/*" -name "*.box" | xargs rm
find . -type f -not -path "./venv/*" -name "*.iso.lock"
find . -type f -not -path "./venv/*" -name "*.iso.lock" | xargs rm
find . -type f -not -path "./venv/*" -name "*.iso"
find . -type f -not -path "./venv/*" -name "*.iso" | xargs rm
find . -type f -not -path "./venv/*" -name "*.ovf"
find . -type f -not -path "./venv/*" -name "*.ovf" | xargs rm
find . -type l -not -path "./venv/*" -name "output-*"
find . -type l -not -path "./venv/*" -name "output-*" | xargs rm
