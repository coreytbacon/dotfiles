#!/usr/bin/env zsh

# ZSH Options
setopt extended_glob
zstyle ':antidote:bundle' use-friendly-names 'yes'
# Autoload functions directory and its subdirs.
for dir in $DOTFILES_CUSTOM/functions $DOTFILES_CUSTOM/functions/*(N/); do
  fpath=($dir $fpath)
  autoload -Uz $fpath[1]/*(.:t)
done
unset dir

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

ZSH_DOTENV_FILE=.env
#ZSH_DOTENV_PROMPT=false

# Be sure to set any supplemental completions directories before compinit is run.
fpath=(${DOTFILES}/completions(-/FN) $fpath)

# Set the name of the static .zsh plugins file antidote will generate.
zsh_plugins=$DOTFILES_PLUGINS_FILE

# Ensure you have a .zsh_plugins.txt file where you can add plugins.
# [[ -f ${DOTFILES_PLUGINS_TEMPLATE} ]] || touch ${DOTFILES_PLUGINS_TEMPLATE}

# Source static plugins file.

# Lazy-load antidote.
fpath+=(${DOTFILES_ANTIDOTE:-~/.dotfiles/.antidote}/.antidote/functions)
autoload -Uz $fpath[-1]/antidote

# Generate static file in a subshell when $DOTFILES_PLUGINS_TEMPLATE is updated.
if [[ ! $zsh_plugins -nt ${DOTFILES_PLUGINS_TEMPLATE} ]]; then
  (antidote bundle <${DOTFILES_PLUGINS_TEMPLATE} >|$DOTFILES_PLUGINS_FILE)
fi
zsh_plugins=$DOTFILES_PLUGINS_FILE

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $zsh_plugins

# vim: ft=zsh sw=2 ts=2 et
