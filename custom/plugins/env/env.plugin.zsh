#!/usr/bin/env zsh
PLUGIN_DIR=$(dirname "$0")

env:source() {
  set -o allexport
  source $1
  set +o allexport
}
