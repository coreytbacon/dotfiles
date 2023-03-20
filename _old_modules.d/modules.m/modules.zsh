#!/usr/bin/env zsh
#CWD="$DOTFILES"
export MODULES="$DOTFILES/modules.d"
export MODULES_DIR="$DOTFILES/modules.d"
# TODO debug
source "$MODULES_DIR/logging.m/logging.zsh"

typeset -a CORE_MODULES=(
  zsh
  logging
  antigen
)

module:load:core() {
  for module in ${CORE_MODULES:-} ; do
      module:load "$module"
  done
}


module:load:all() {
  for module in $(find -H "$MODULES_DIR" -type d -name '[^_]*.m' -not -path '*.git' -execdir echo {} ';'); do
    module:load "$module"
  done
}

module:load() {
  module=${1%".m"}
  if [ -f "$MODULES_DIR/$module.m/$module.zsh" ]; then
    MODULE_DIR="$MODULES_DIR/$module.m" source  "$MODULES_DIR/$module.m/$module.zsh"
  fi
}


file_search_parents() {
  #DIR=$(readlink -f "$1")
  # Alternative: use current working dir; but then also replace ${@:2} with $@ on line 8
  # and $1 with $PWD when calling realpath
  DIR=$PWD

  while
    RESULT=$(find "$DIR" -maxdepth 1 -name "$@")
    # echo "Debugging upfind - search in $DIR gives: $RESULT"
    [[ -z $RESULT ]] && [[ "$DIR" != "/" ]]
  do DIR=$(dirname "$DIR"); done
  # Alternative: output absolute path

  echo "$RESULT"
}

# DEBUGGING
module:source(){
  typeset -a EXCLUDED_FILES=(
    BASH_SOURCE
  )
  SCRIPT_SELF=$(realpath "$0")
  for file in $1/**/[^_]*; do
    if [ "$file" -ef "$SCRIPT_SELF" ]; then
      continue
    fi
    source "$file"
  done

}

module:list() {
  #local dotModules=$(find -H "$DOTFILES" -name '*.m' -not -path '*.git')
  for module in $(find -H "$MODULES_DIR" -type d -name '[^_]*.m' -not -path '*.git' -execdir echo {} ';')
  do
    log:info "Module: [$module]"
  done
}
