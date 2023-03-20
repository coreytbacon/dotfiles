#!/usr/bin/env zsh
# setup

# Aliases
alias antidote:purge='rm -rf $(antidote home) && rm ${ZDOTDIR:-~}/.zsh_plugins.zsh'
alias antidote:bundle='antidote bundle <${DOTFILES_PLUGINS_TEMPLATE} >|$DOTFILES_PLUGINS_FILE'
alias antidote:list='antidote list'
alias antidote:update='antidote update'
alias antidote:home='antidote home'
alias antidote:help='antidote update'
