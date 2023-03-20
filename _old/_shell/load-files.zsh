#!/bin/sh

# TODO enable and integrate
load_files_test() {

  for path in $(find "${1}" -type f -not -path '*/_*/*' ! -name '_*' -print0)
  do
    case "${c}" in (*.zsh|*.sh|*.*)
      #filename="${path##*/}"
      #extension=$([[ "$filename" = *.* ]] && echo ".${filename##*.}" || echo '')
      #files+=("$path")
      echo "F1: ${path}"
    esac
  done

}
