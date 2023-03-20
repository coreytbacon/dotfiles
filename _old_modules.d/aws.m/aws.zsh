#!/usr/bin/env zsh
MODULE_DIR=$(dirname "$0")
typeset -a EXCLUDED_FILES=(
  BASH_SOURCE
)
SCRIPT_SELF=$(realpath "$0")
