#!/bin/zsh

# Prefix for all functions
FUNCTION_PREFIX="module"
# Debug logging
DEBUG=0
# TODO utilise

${FUNCTION_PREFIX}"::load" () {
  # Enable logging
  # Enable log functions
  source "$DOTFILES/_shell/logging.zsh"
  module_name=${1}
  file_prefix=${2:-'_'} # TODO

  module_dir="$DOTFILES"/"${module_name}"
  module_zsh_files=("$module_dir"/[^_]*.zsh)

  if [ -z $DEBUG ]; then
    log:info "LOADING MODULE [$module_name]"
  fi
  # Check for entry.zsh
  if [ -f "$module_dir"/entry.zsh ]; then
    if [ -z $DEBUG ]; then
        log:info "LOADED ENTRY [$module_name/entry.zsh]"
    fi
    source "$module_dir"/entry.zsh
  fi

  # Load remaining not entry/exit.zsh files
  for file in ${${module_zsh_files:#*/entry.zsh}:#*/exit.zsh}
  do
    if [ -z $DEBUG ]; then
      log:info "LOADED MODULE FILE [$module_name/$(basename $file)]"
    fi
    source "$file"
  done

 # Check for exit.zsh
  if [ -f "$module_dir"/exit.zsh ]; then
    if [ -z $DEBUG ]; then
      log:info "LOADED EXIT [$module_name/exit.zsh]"
    fi
    source "$module_dir"/exit.zsh
  fi
}
