#docker pull jetbrains/qodana-php
#

function qodana_docker (){
  local source_dir=${PWD}
  local output_dir="$source_dir/"${1:-'.qodana-reports'}

  docker run --rm -it -p 8080:8080 \
  -v "$source_dir/:/data/project/" \
  -v "$output_dir/:/data/results/" \
  jetbrains/qodana-php --show-report
}
