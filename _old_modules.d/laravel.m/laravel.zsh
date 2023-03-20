#!/usr/bin/env zsh
MODULE_DIR="$MODULES_DIR/laravel.m"



_precmd_hook() {
  MODULE_DIR="$MODULES_DIR/laravel.m"
  ARTISAN_BINARY=$(file_search_parents "artisan")
  if [ -n "$ARTISAN_BINARY" ]; then
    log:info "Sourcing $MODULE_DIR/artisan"
    module:source "$MODULE_DIR/artisan"
  fi
}
_predir_hook() {
  MODULE_DIR="$MODULES_DIR/laravel.m"
  ARTISAN_BINARY=$(file_search_parents "artisan")
  if [ -n "$ARTISAN_BINARY" ]; then
    log:info "Sourcing $MODULE_DIR/artisan"
    module:source "$MODULE_DIR/artisan"
  fi
}


typeset -ag precmd_functions;
if [[ -z ${precmd_functions[(r)_precmd_hook]} ]]; then
  precmd_functions=( _precmd_hook ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z ${chpwd_functions[(r)_predir_hook]} ]]; then
  chpwd_functions=( _predir_hook ${chpwd_functions[@]} )
fi




laravel:new() {
  curl -s "https://laravel.build/${1:-example-app}" | bash
}

#logs
laravel:logs:clear() {

  logs_dir='storage/logs/laravel.log'

  if [[ ! -f "$logs_dir" ]]; then
      logs_dir="$PWD/storage/logs/laravel.log"
  fi

  if [[ -f "$logs_dir" ]]; then
      echo '' > $logs_dir
  else
    log:error "Unable to find laravel.log file at [$logs_dir]"
  fi
}
