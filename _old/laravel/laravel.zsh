#!/usr/bin/env zsh

FUNCTION_PREFIX="laravel"

${FUNCTION_PREFIX}":new" () {
  curl -s "https://laravel.build/${1:-example-app}" | bash
}

#logs
${FUNCTION_PREFIX}":logs:clear" () {

  logs_dir='storage/logs/laravel.log'

  if [[ ! -f "$logs_dir" ]]; then
      logs_dir="$PWD/storage/logs/laravel.log"
  fi

  if [[ -f "$logs_dir" ]]; then
      echo '' > $logs_dir
  else
    log:errorne "Unable to find laravel.log file at [$logs_dir]"
  fi
}
