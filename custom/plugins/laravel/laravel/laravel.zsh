#!/usr/bin/env zsh

laravel:test() {
  echo "test: ${PLUGIN_DIR}"
}
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
