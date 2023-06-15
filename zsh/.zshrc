#!/usr/bin/env zsh=

# Lazy-load antidote.
fpath+=($DOTFILES_ANTIDOTE_INSTALL)
autoload -Uz $fpath[-1]/antidote

# Generate static file in a subshell when .zsh_plugins.txt is updated.
if [[ ! $DOTFILES_PLUGINS_FILE -nt $DOTFILES_PLUGINS_TEMPLATE ]]; then
  (antidote bundle <$DOTFILES_PLUGINS_TEMPLATE >|$DOTFILES_PLUGINS_FILE)
fi

# Source your static plugins file.
source $DOTFILES_PLUGINS_FILE
