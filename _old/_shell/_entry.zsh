
# Module name - example: _shell
module_name=$(basename $(dirname "$0"))
# Check for module.zsh
if [ -f "$DOTFILES/$module_name"/module.zsh ]; then
  source "$DOTFILES/$module_name"/module.zsh
  module::load "$module_name"
else
  printf "error loading $DOTFILES/$module_name/module.zsh utils\n"
fi
