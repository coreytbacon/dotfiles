# bacon does dotfiles

## thanks
I forked [Holman](http://github.com/ryanb) excellent
[dotfiles](http://github.com/holman/dotfiles)

Things have changed a lot since then

# How it works
Everything is organised into 'modules'
A module can consist of:
* entry.zsh
  * Any pre-configuration in here
* path.zsh
  * Any $PATH changes go in here
* {any-name}.zsh
  * aliases.zsh, functions.zsh, and anything else you want to load
* completion.zsh
  * Add any configuration related to autocomplete in here
* exit.zsh
  * Any cleanup tasks etc.
