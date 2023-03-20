#!/bin/zsh

# SYMBOLIC_LINK_BEHAVIOR: https://www.man7.org/linux/man-pages/man1/find.1.html#:~:text=source%20of%20information.-,OPTIONS,-top
SYMBOLIC_LINK_BEHAVIOR=-H
INCLUDE_HIDDEN=true

function get_all_modules() {
  #local dotModules=$(find -H "$DOTFILES" -name '*.m' -not -path '*.git')
  for module in $(find -H "$DOTFILES" -type d -name '[^_]*.m' -not -path '*.git')
  do
    log:info "Module: [$module]\n\n"
  done
}

function get_autoloaded_modules() {
  #local dotModules=$(find -H "$DOTFILES" -name '*.m' -not -path '*.git')
  # config_files=($DOTFILES/**/[^_]*/[^_]*.zsh)
  count=0

  #mapfile -t modules < <(find -H "$DOTFILES" -type d -name '[^_]*.m' -not \( -path '*/_*'  -prune \) -not -path '*.git' print0)
  #local modules=$(find -H "$DOTFILES" -type d -name '[^_]*.m' -not \( -path '*/_*'  -prune \) -not -path '*.git')

  modulesA=( $(find -H "$DOTFILES" -type d -name '[^_]*.m' -not \( -path '*/_*'  -prune \) -not -path '*.git' -print0) )


  for module in $modulesA
  do
    count=$((count + 1))
    log:info "Module [$count] [autoloaded]: [$module]"
  done
}