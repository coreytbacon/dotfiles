php:link() {
  phpVersion=$1
  {brew link php@${phpVersion} --force --overwrite; } &> /dev/null && php -v
}

php:set() {
  phpVersion=$1
  installedPHPVersions=("${(@f)$(brew ls --versions | ggrep -E 'php(@.*)?\s' | ggrep -oP '(?<=\s)\d\.\d' | uniq | sort)}")

  if [[ $# -eq 1 && -z "$phpVersion" ]]; then
    php:link "$1"
  else

    select version in "${installedPHPVersions[@]}"
    do
      if [[ " ${installedPHPVersions[*]} " =~ " ${version} " ]]; then
          echo "Setting php to version $version"
          php:link $version
          break;
      else
        echo "Invalid option: $version"
      fi
    done
  fi
}
