####  START [/Users/coreybacon/.dotfiles/direnv/entry.zsh]  ####
XDG_CONFIG_HOME=
#### END [/Users/coreybacon/.dotfiles/direnv/entry.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/hooks/entry.zsh]  ####


#### END [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/hooks/entry.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/hooks/entry.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/hooks/entry.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/composer/path.zsh]  ####
export PATH="$HOME/.composer/vendor/bin:$PATH"
#### END [/Users/coreybacon/.dotfiles/composer/path.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/homebrew/path.zsh]  ####
export PATH="/opt/homebrew/bin:$PATH"
#### END [/Users/coreybacon/.dotfiles/homebrew/path.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/magento/path.zsh]  ####
export PATH="~/.magento-cloud/bin:$PATH"

#### END [/Users/coreybacon/.dotfiles/magento/path.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/ruby/path.zsh]  ####
export PATH="/usr/local/opt/ruby:$PATH"

#### END [/Users/coreybacon/.dotfiles/ruby/path.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/system/path.zsh]  ####
export PATH="./bin:/usr/local/bin:/usr/local/sbin:$DOTFILES/bin:/usr/local/opt/ruby/bin:$PATH"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

#### END [/Users/coreybacon/.dotfiles/system/path.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/hooks/path.zsh]  ####
# Oh my ZSH
export ZSH="$HOME/.oh-my-zsh"
#### END [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/hooks/path.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/hooks/path.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/hooks/path.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/yarn/path.zsh]  ####
# sup yarn
# https://yarnpkg.com

if (( $+commands[yarn] ))
then
  export PATH="$PATH:`yarn global bin`"
fi

#### END [/Users/coreybacon/.dotfiles/yarn/path.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/_modules/modules/functions.zsh]  ####
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
#### END [/Users/coreybacon/.dotfiles/_modules/modules/functions.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/_modules/modules/modules.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/_modules/modules/modules.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/aws/aws/functions.zsh]  ####
function agp() {
  echo $AWS_PROFILE
}

# AWS profile selection
function asp() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE
    echo AWS profile cleared.
    return
  fi

  local -a available_profiles
  available_profiles=($(aws_profiles))
  if [[ -z "${available_profiles[(r)$1]}" ]]; then
    echo "${fg[red]}Profile '$1' not found in '${AWS_CONFIG_FILE:-$HOME/.aws/config}'" >&2
    echo "Available profiles: ${(j:, :)available_profiles:-no profiles found}${reset_color}" >&2
    return 1
  fi

  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
  export AWS_EB_PROFILE=$1

  if [[ "$2" == "login" ]]; then
    aws sso login
  fi
}

# AWS profile switch
function acp() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
    echo AWS profile cleared.
    return
  fi

  local -a available_profiles
  available_profiles=($(aws_profiles))
  if [[ -z "${available_profiles[(r)$1]}" ]]; then
    echo "${fg[red]}Profile '$1' not found in '${AWS_CONFIG_FILE:-$HOME/.aws/config}'" >&2
    echo "Available profiles: ${(j:, :)available_profiles:-no profiles found}${reset_color}" >&2
    return 1
  fi

  local profile="$1"
  local mfa_token="$2"

  # Get fallback credentials for if the aws command fails or no command is run
  local aws_access_key_id="$(aws configure get aws_access_key_id --profile $profile)"
  local aws_secret_access_key="$(aws configure get aws_secret_access_key --profile $profile)"
  local aws_session_token="$(aws configure get aws_session_token --profile $profile)"


  # First, if the profile has MFA configured, lets get the token and session duration
  local mfa_serial="$(aws configure get mfa_serial --profile $profile)"
  local sess_duration="$(aws configure get duration_seconds --profile $profile)"

  if [[ -n "$mfa_serial" ]]; then
    local -a mfa_opt
    if [[ -z "$mfa_token" ]]; then
      echo -n "Please enter your MFA token for $mfa_serial: "
      read -r mfa_token
    fi
    if [[ -z "$sess_duration" ]]; then
      echo -n "Please enter the session duration in seconds (900-43200; default: 3600, which is the default maximum for a role): "
      read -r sess_duration
    fi
    mfa_opt=(--serial-number "$mfa_serial" --token-code "$mfa_token" --duration-seconds "${sess_duration:-3600}")
  fi

  # Now see whether we need to just MFA for the current role, or assume a different one
  local role_arn="$(aws configure get role_arn --profile $profile)"
  local sess_name="$(aws configure get role_session_name --profile $profile)"

  if [[ -n "$role_arn" ]]; then
    # Means we need to assume a specified role
    aws_command=(aws sts assume-role --role-arn "$role_arn" "${mfa_opt[@]}")

    # Check whether external_id is configured to use while assuming the role
    local external_id="$(aws configure get external_id --profile $profile)"
    if [[ -n "$external_id" ]]; then
      aws_command+=(--external-id "$external_id")
    fi

    # Get source profile to use to assume role
    local source_profile="$(aws configure get source_profile --profile $profile)"
    if [[ -z "$sess_name" ]]; then
      sess_name="${source_profile:-profile}"
    fi
    aws_command+=(--profile="${source_profile:-profile}" --role-session-name "${sess_name}")

    echo "Assuming role $role_arn using profile ${source_profile:-profile}"
  else
    # Means we only need to do MFA
    aws_command=(aws sts get-session-token --profile="$profile" "${mfa_opt[@]}")
    echo "Obtaining session token for profile $profile"
  fi

  # Format output of aws command for easier processing
  aws_command+=(--query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' --output text)

  # Run the aws command to obtain credentials
  local -a credentials
  credentials=(${(ps:\t:)"$(${aws_command[@]})"})

  if [[ -n "$credentials" ]]; then
    aws_access_key_id="${credentials[1]}"
    aws_secret_access_key="${credentials[2]}"
    aws_session_token="${credentials[3]}"
  fi

  # Switch to AWS profile
  if [[ -n "${aws_access_key_id}" && -n "$aws_secret_access_key" ]]; then
    export AWS_DEFAULT_PROFILE="$profile"
    export AWS_PROFILE="$profile"
    export AWS_EB_PROFILE="$profile"
    export AWS_ACCESS_KEY_ID="$aws_access_key_id"
    export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"

    if [[ -n "$aws_session_token" ]]; then
      export AWS_SESSION_TOKEN="$aws_session_token"
    else
      unset AWS_SESSION_TOKEN
    fi

    echo "Switched to AWS Profile: $profile"
  fi
}

function aws_change_access_key() {
  if [[ -z "$1" ]]; then
    echo "usage: $0 <profile>"
    return 1
  fi

  echo "Insert the credentials when asked."
  asp "$1" || return 1
  AWS_PAGER="" aws iam create-access-key
  AWS_PAGER="" aws configure --profile "$1"

  echo "You can now safely delete the old access key running \`aws iam delete-access-key --access-key-id ID\`"
  echo "Your current keys are:"
  AWS_PAGER="" aws iam list-access-keys
}

function aws_profiles() {
  [[ -r "${AWS_CONFIG_FILE:-$HOME/.aws/config}" ]] || return 1
  grep --color=never -Eo '\[.*\]' "${AWS_CONFIG_FILE:-$HOME/.aws/config}" | sed -E 's/^[[:space:]]*\[(profile)?[[:space:]]*([^[:space:]]+)\][[:space:]]*$/\2/g'
}

function _aws_profiles() {
  reply=($(aws_profiles))
}
compctl -K _aws_profiles asp acp aws_change_access_key

# AWS prompt
function aws_prompt_info() {
  [[ -n "$AWS_PROFILE" ]] || return
  echo "${ZSH_THEME_AWS_PREFIX=<aws:}${AWS_PROFILE:gs/%/%%}${ZSH_THEME_AWS_SUFFIX=>}"
}

if [[ "$SHOW_AWS_PROMPT" != false && "$RPROMPT" != *'$(aws_prompt_info)'* ]]; then
  RPROMPT='$(aws_prompt_info)'"$RPROMPT"
fi


# Load awscli completions

# AWS CLI v2 comes with its own autocompletion. Check if that is there, otherwise fall back
if command -v aws_completer &> /dev/null; then
  autoload -Uz bashcompinit && bashcompinit
  complete -C aws_completer aws
else
  function _awscli-homebrew-installed() {
    # check if Homebrew is installed
    (( $+commands[brew] )) || return 1

    # speculatively check default brew prefix
    if [ -h /usr/local/opt/awscli ]; then
      _brew_prefix=/usr/local/opt/awscli
    else
      # ok, it is not in the default prefix
      # this call to brew is expensive (about 400 ms), so at least let's make it only once
      _brew_prefix=$(brew --prefix awscli)
    fi
  }

  # get aws_zsh_completer.sh location from $PATH
  _aws_zsh_completer_path="$commands[aws_zsh_completer.sh]"

  # otherwise check common locations
  if [[ -z $_aws_zsh_completer_path ]]; then
    # Homebrew
    if _awscli-homebrew-installed; then
      _aws_zsh_completer_path=$_brew_prefix/libexec/bin/aws_zsh_completer.sh
    # Ubuntu
    elif [[ -e /usr/share/zsh/vendor-completions/_awscli ]]; then
      _aws_zsh_completer_path=/usr/share/zsh/vendor-completions/_awscli
    # NixOS
    elif [[ -e "${commands[aws]:P:h:h}/share/zsh/site-functions/aws_zsh_completer.sh" ]]; then
      _aws_zsh_completer_path="${commands[aws]:P:h:h}/share/zsh/site-functions/aws_zsh_completer.sh"
    # RPM
    else
      _aws_zsh_completer_path=/usr/share/zsh/site-functions/aws_zsh_completer.sh
    fi
  fi

  [[ -r $_aws_zsh_completer_path ]] && source $_aws_zsh_completer_path
  unset _aws_zsh_completer_path _brew_prefix
fi


# Custom
function arole (){
  acp "${1}" "$(aws_mfa_token)"
}

function aws_mfa_token (){
  echo "$(oathtool --totp --base32 $(get_mfa_token))"
}
function get_mfa_token (){
  echo $(<$HOME/.aws/corey.bacon.aws.mfa)
}
function decrypt_mfa (){
  echo "not working..."
  echo $(openssl des -d -in corey.bacon.mfa.enc -out corey.bacon.aws.mfa)
}

#### END [/Users/coreybacon/.dotfiles/aws/aws/functions.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/composer/aliases.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/composer/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/docker/aliases.zsh]  ####
alias d='docker $*'
alias d-c='docker-compose $*'

#### END [/Users/coreybacon/.dotfiles/docker/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/docker/functions.zsh]  ####
#macro to kill the docker desktop app and the VM (excluding vmnetd -> it's a service)
function kdo() {
  ps ax | grep -i docker| egrep -iv 'grep|com.docker.vmnetd' | awk '{print $1}' | xargs kill
}
#### END [/Users/coreybacon/.dotfiles/docker/functions.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/docker/pulls.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/docker/pulls.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/fzf/fzf.zsh]  ####
# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
#### END [/Users/coreybacon/.dotfiles/fzf/fzf.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/git/aliases.zsh]  ####
# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi

# The rest of my fun git aliases
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'

# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'

alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gcb='git copy-branch-name'
alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gac='git add -A && git commit -m'
alias ge='git-edit-new'


# DEFAULT ALIASES
#g
#
#git
#ga
#
#git add
#gau
#
#git add --update (Also: "git add -u")
#gaa
#
#git add --all
#gapa
#
#git add --patch
#gb
#
#git branch
#gba
#
#git branch -a
#gbd
#
#git branch -d
#gbda
#
#git branch --no-color --merged | command grep -vE "^(+|*|\s*($(git_main_branch)|development|develop|devel|dev)\s*$)" | command xargs -n 1 git branch -d
#gbl
#
#git blame -b -w
#gbnm
#
#git branch --no-merged
#gbr
#
#git branch --remote
#gbs
#
#git bisect
#gbsb
#
#git bisect bad
#gbsg
#
#git bisect good
#gbsr
#
#git bisect reset
#gbss
#
#git bisect start
#gc
#
#git commit -v
#gc!
#
#git commit -v --amend
#gca
#
#git commit -v -a
#gca!
#
#git commit -v -a --amend
#gcan!
#
#git commit -v -a --no-edit --amend
#gcans!
#
#git commit -v -a -s --no-edit --amend
#gcam
#
#git commit -a -m
#gcsm
#
#git commit -s -m
#gcb
#
#git checkout -b
#gcf
#
#git config --list
#gcl
#
#git clone --recurse-submodules
#gclean
#
#git clean -id
#gpristine
#
#git reset --hard && git clean -dffx
#gcm
#
#git checkout $(git_main_branch)
#gcd
#
#git checkout develop
#gcmsg
#
#git commit -m
#gco
#
#git checkout
#gcount
#
#git shortlog -sn
#gcp
#
#git cherry-pick
#gcpa
#
#git cherry-pick --abort
#gcpc
#
#git cherry-pick --continue
#gcs
#
#git commit -S
#gd
#
#git diff
#gdca
#
#git diff --cached
#gdct
#
#git describe --tags `git rev-list --tags --max-count=1`
#gds
#
#git diff --staged
#gdt
#
#git diff-tree --no-commit-id --name-only -r
#gdw
#
#git diff --word-diff
#gf
#
#git fetch
#gfa
#
#git fetch --all --prune
#gfo
#
#git fetch origin
#gg
#
#git gui citool
#gga
#
#git gui citool --amend
#ggpnp
#
#git pull origin $(current_branch) && git push origin $(current_branch)
#ggpull
#
#git pull origin $(current_branch)
#ggl
#
#git pull origin $(current_branch)
#ggpur
#
#git pull --rebase origin $(current_branch)
#ggu
#
#git pull --rebase origin $(current_branch)
#glum
#
#git pull upstream $(git_main_branch)
#ggpush
#
#git push origin $(current_branch)
#ggp
#
#git push origin $(current_branch)
#ggf
#
#git push --force origin $(current_branch)
#ggfl
#
#git push --force-with-lease origin $(current_branch)
#ggsup
#
#git branch --set-upstream-to=origin/$(current_branch)
#gpsup
#
#git push --set-upstream origin $(current_branch)
#ghh
#
#git help
#gignore
#
#git update-index --assume-unchanged
#gignored
#
#git ls-files -v | grep "^[[:lower:]]"
#git-svn-dcommit-push
#
#git svn dcommit && git push github $(git_main_branch):svntrunk
#gk
#
#\gitk --all --branches
#gke
#
#\gitk --all $(git log -g --pretty=%h)
#gl
#
#git pull
#glg
#
#git log --stat
#glgg
#
#git log --graph
#glgga
#
#git log --graph --decorate --all
#glgm
#
#git log --graph --max-count=10
#glgp
#
#git log --stat -p
#glo
#
#git log --oneline --decorate
#glog
#
#git log --oneline --decorate --graph
#glol
#
#git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
#glola
#
#git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all
#glp
#
#_git_log_prettily (Also: "git log --pretty=$1")
#gm
#
#git merge
#gma
#
#git merge --abort
#gmom
#
#git merge origin/$(git_main_branch)
#gmt
#
#git mergetool --no-prompt
#gmtvim
#
#git mergetool --no-prompt --tool=vimdiff
#gmum
#
#git merge upstream/$(git_main_branch)
#gp
#
#git push
#gpd
#
#git push --dry-run
#gpf
#
#git push --force-with-lease
#gpf!
#
#git push --force
#gpoat
#
#git push origin --all && git push origin --tags
#gpu
#
#git push upstream
#gpv
#
#git push -v
#gr
#
#git remote
#gra
#
#git remote add
#grb
#
#git rebase
#grba
#
#git rebase --abort
#grbc
#
#git rebase --continue
#grbd
#
#git rebase develop
#grbi
#
#git rebase -i
#grbm
#
#git rebase $(git_main_branch)
#grbs
#
#git rebase --skip
#grh
#
#git reset (Also: "git reset HEAD")
#grhh
#
#git reset --hard (Also: "git reset HEAD --hard")
#grmv
#
#git remote rename
#grrm
#
#git remote remove
#grs
#
#git restore
#grset
#
#git remote set-url
#grss
#
#git restore --source
#grst
#
#git restore --staged
#grt
#
#cd "$(git rev-parse --show-toplevel || echo .)"
#gru
#
#git reset --
#grup
#
#git remote update
#grv
#
#git remote -v
#gsb
#
#git status -sb
#gsd
#
#git svn dcommit
#gsi
#
#git submodule init
#gsps
#
#git show --pretty=short --show-signature
#gsr
#
#git svn rebase
#gss
#
#git status -s
#gst
#
#git status
#gsta
#
#git stash push
#gstaa
#
#git stash apply
#gstd
#
#git stash drop
#gstl
#
#git stash list
#gstp
#
#git stash pop
#gstc
#
#git stash clear
#gsts
#
#git stash show --text
#gsu
#
#git submodule update
#gts
#
#git tag -s
#gunignore
#
#git update-index --no-assume-unchanged
#gunwip
#
#git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1
#gup
#
#git pull --rebase
#gupv
#
#git pull --rebase -v
#gvt
#
#git verify-tag
#gwch
#
#git whatchanged -p --abbrev-commit --pretty=medium
#gwip
#
#git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"

#### END [/Users/coreybacon/.dotfiles/git/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/homebrew/aliases.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/homebrew/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/homebrew/formula.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/homebrew/formula.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/jetbrains/phpstorm/default/qodana/docker.zsh]  ####
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

#### END [/Users/coreybacon/.dotfiles/jetbrains/phpstorm/default/qodana/docker.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/jetbrains/phpstorm/default/qodana/qodana.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/jetbrains/phpstorm/default/qodana/qodana.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/laravel/artisan/aliases.zsh]  ####
#!/usr/bin/env zsh


function art_make() {
    artisan make:$*
}

# Aliases
alias artisan='php artisan'
alias serve='artisan serve'
alias tinker='artisan tinker'
alias a='artisan'
alias migrate="artisan migrate"

# general
alias a='artisan'
alias av='artisan -V'
alias acc='artisan clear-compiled'
alias ad='artisan down'
alias ae='artisan env'
alias ah='artisan help'
alias ai='artisan inspire'
alias al='artisan list'
alias ap='artisan preset'
alias as='artisan serve'
alias at='artisan tinker'
alias au='artisan up'

#app
alias aanm='artisan app:name'

#auth
alias aacr='artisan auth:clear-resets'

# cache
alias accl='artisan cache:clear'
alias acfg='artisan cache:forget'
alias actb='artisan cache:table'

# config
alias acfcc='artisan config:cache'
alias acfcl='artisan config:clear'

# common
alias adbs='artisan db:seed'
alias aeg='artisan event:generate'
alias akg='artisan key:generate'

# make
alias amkau='art_make auth'
alias amkch='art_make channel'
alias amkcm='art_make command'
alias amkct='art_make controller'
alias amkctr='art_make controller -r'
alias amkev='art_make event'
alias amkex='art_make exception'
alias amkfc='art_make factory'
alias amkjb='art_make job'
alias amkls='art_make listener'
alias amkml='art_make mail'
alias amkmw='art_make middleware'
alias amkmg='art_make migration'
alias amkmd='art_make model'
alias amkmdm='art_make model -m'
alias amknf='art_make notification'
alias amkos='art_make observer'
alias amkpl='art_make policy'
alias amkpv='art_make provider'
alias amkrq='art_make request'
alias amkres='art_make resource'
alias amkrl='art_make rule'
alias amksd='art_make seeder'
alias amkts='art_make test'

# migrate
alias amg='artisan migrate'
alias amgf='artisan migrate --force'
alias amgs='artisan migrate --seed'
alias amgp='artisan migrate --pretend'
alias amgt='artisan migrate --env=testing'
alias amgfr='artisan migrate:fresh'
alias amgis='artisan migrate:install'
alias amgrf='artisan migrate:refresh'
alias amgrs='artisan migrate:reset'
alias amgrb='artisan migrate:rollback'
alias amgst='artisan migrate:status'

# notifications
alias anftb='artisan notifications:table'

# optimize
alias ao='artisan optimize'
alias aoc='artisan optimize:clear'

# package
alias apd='artisan package:discover'

# queue
alias aqf='artisan queue:failed'
alias aqft='artisan queue:failed-table'
alias aqfl='artisan queue:flush'
alias aqfg='artisan queue:forget'
alias aqls='artisan queue:listen'
alias aqrs='artisan queue:restart'
alias aqrt='artisan queue:retry'
alias aqtb='artisan queue:table'
alias aqwk='artisan queue:work'

# route
alias arcc='artisan route:cache'
alias arcl='artisan route:clear'
alias arls='artisan route:list'

# schedule
alias asfn='artisan schedule:finish'
alias asrn='artisan schedule:run'

# session
alias astb='artisan session:table'

# storage
alias asln='artisan storage:link'

# vendor
alias avpb='artisan vendor:publish'

# view
alias avcc='artisan view:cache'
alias avcl='artisan view:clear'

# horizon
alias ahz='artisan horizon'
alias ahzas='artisan horizon:assets'
alias ahzct='artisan horizon:continue'
alias ahzls='artisan horizon:list'
alias ahzps='artisan horizon:pause'
alias ahzpg='artisan horizon:purge'
alias ahzss='artisan horizon:snapshot'
alias ahzsv='artisan horizon:supervisor'
alias ahzsvs='artisan horizon:supervisors'
alias ahztm='artisan horizon:terminate'
alias ahzto='artisan horizon:timeout'
alias ahzwk='artisan horizon:work'

# old framework versions commands
alias amkcs='art_make console'
alias ahcm='artisan handler:command'
alias ahev='artisan handler:event'
alias aqss='artisan queue:subscribe'
alias afr='artisan fresh'
#### END [/Users/coreybacon/.dotfiles/laravel/artisan/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/laravel/artisan/functions.zsh]  ####
#!/usr/bin/env zsh

#### END [/Users/coreybacon/.dotfiles/laravel/artisan/functions.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/laravel/laravel.zsh]  ####
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

#### END [/Users/coreybacon/.dotfiles/laravel/laravel.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/laravel/sail/aliases.zsh]  ####
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
#### END [/Users/coreybacon/.dotfiles/laravel/sail/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/magento/magento-cloud.zsh]  ####
if [ -f "$HOME/"'.magento-cloud/shell-config.rc' ]; 
	then . "$HOME/"'.magento-cloud/shell-config.rc'; 
fi
#### END [/Users/coreybacon/.dotfiles/magento/magento-cloud.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/node/nvm.zsh]  ####
# Export NVM_DIR
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
# This loads nvm bash_completion
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
#### END [/Users/coreybacon/.dotfiles/node/nvm.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/php/aliases.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/php/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/php/phpcs/aliases.zsh]  ####
alias phpcs='phpcs'
alias phpcbf='phpcbf'
alias pcs='phpcs'
alias pcbf='phpcbf'



#### END [/Users/coreybacon/.dotfiles/php/phpcs/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/php/versions.zsh]  ####
# determine versions of PHP installed with HomeBrew
installedPhpVersions=($(brew ls --versions | ggrep -E 'php(@.*)?\s' | ggrep -oP '(?<=\s)\d\.\d' | uniq | sort))

# create alias for every version of PHP installed with HomeBrew
# format: php@v - example: php@8.1
for phpVersion in ${installedPhpVersions[*]}; do
    value="{"

    for otherPhpVersion in ${installedPhpVersions[*]}; do
        if [ "${otherPhpVersion}" = "${phpVersion}" ]; then
            continue
        fi

        # unlink other PHP version
        value="${value} brew unlink php@${otherPhpVersion};"
    done

    # link desired PHP version
    value="${value} brew link php@${phpVersion} --force --overwrite; } &> /dev/null && php -v"

    alias "php@${phpVersion}"="${value}"
done
#### END [/Users/coreybacon/.dotfiles/php/versions.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/ruby/aliases.zsh]  ####
#alias ruby='/usr/local/opt/ruby/bin/ruby'
source /usr/local/opt/chruby/share/chruby/chruby.sh

#### END [/Users/coreybacon/.dotfiles/ruby/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/ssh/aliases.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/ssh/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/ssh/xxh/aliases.zsh]  ####
alias xsh="xxh"
#### END [/Users/coreybacon/.dotfiles/ssh/xxh/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/system/aliases.zsh]  ####
# TODO move to own modules
alias help="tldr"
alias top="sudo htop"
alias yt="youtube-dl"
alias reload="exec zsh"
alias finder="open -a Finder ./"
alias weather="curl -4 https://wttr.in/Brussels"
alias md='mkdir -p'
alias please=sudo
alias d='dirs -v | head -10'
alias ip='curl ifconfig.io'

# TODO check if needed
## misc git alias
#alias g=git
#alias gc='git commit -a -m'
## g c "Commit message goes here"
#alias f="!git fetch --all && git pull origin/master"
#alias n="!git checkout -b"
#alias gs='git status -sb'
#alias gstats='git shortlog -sn --all --no-merges'
#alias grecent='git for-each-ref --count=10 --sort=-committerdate refs/heads/ --format="%(refname:short)"'
#alias gfix='git commit --amend --no-edit'
#
#alias repo='gh repo view -w'
#### END [/Users/coreybacon/.dotfiles/system/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/system/cat/aliases.zsh]  ####
# OLD ALIAS alias cat='bat --color=always --style=numbers,changes,grid,default'
alias cat='bat --style=numbers,changes,grid,default'

#### END [/Users/coreybacon/.dotfiles/system/cat/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/system/env.zsh]  ####
export EDITOR='subl'

#### END [/Users/coreybacon/.dotfiles/system/env.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/system/grc.zsh]  ####
# GRC colorizes nifty unix tools all over the place
if (( $+commands[grc] )) && (( $+commands[brew] ))
then
  source `brew --prefix`/etc/grc.bashrc
fi

#### END [/Users/coreybacon/.dotfiles/system/grc.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/system/keys.zsh]  ####
# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

#### END [/Users/coreybacon/.dotfiles/system/keys.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/system/ls/aliases.zsh]  ####
# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`

ls_command='ls'
if $(gls &>/dev/null)
then
  ls_command='gls'
fi
alias l="${ls_command} -lFAh --color"
alias ls="${ls_command} -lAFh --color" #long list,show almost all,show type,human readable
alias lr="${ls_command} -tRFh"        #sorted by date,recursive,show type,human readable
alias ll="${ls_command} -l --color"
alias la="${ls_command} -Al --color"

alias lt="${ls_command} -ltFh"        #long list,sorted by date,show type,human readable
alias ll="${ls_command} -l"           #long list
alias ldot="${ls_command} -ld .*"
alias lS="${ls_command} -1FSsh"
alias lart="${ls_command} -1Fcart"
alias lrt="${ls_command} -1Fcrt"
#### END [/Users/coreybacon/.dotfiles/system/ls/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/config.zsh]  ####
ZSH_ALIAS_FINDER_AUTOMATIC=true
#### END [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/config.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/plugins.zsh]  ####
plugins=(
  alias-finder
  brew
  common-aliases
  copypath
  copyfile
  docker
  docker-compose
  #dotenv
  #autoenv
  direnv
  encode64
  extract
  git
  jira
  jsontools
  node
  npm
  macos
  urltools
  vscode
  web-search
  wakatime
  history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
  n98-magerun
)
#### END [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/plugins.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/test1.m/echo.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/_module-tests/test1.m/echo.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/config.zsh]  ####
ZSH_ALIAS_FINDER_AUTOMATIC=true
#### END [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/config.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/echo.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/echo.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/module.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/module.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/plugins.zsh]  ####
plugins=(
  alias-finder
  brew
  common-aliases
  copypath
  copyfile
  docker
  docker-compose
  #dotenv
  #autoenv
  direnv
  encode64
  extract
  git
  jira
  jsontools
  node
  npm
  macos
  urltools
  vscode
  web-search
  wakatime
  history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
  n98-magerun
)
#### END [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/plugins.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/test_3.m/echo.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/_module-tests/test_3.m/echo.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/test_3.m/test_3_1.m/echo.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/_module-tests/test_3.m/test_3_1.m/echo.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/module-tests/_test1.m/test1.2.m/echo.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/module-tests/_test1.m/test1.2.m/echo.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/module-tests/test3.m/echo.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/module-tests/test3.m/echo.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/module-tests/test3.m/test3.1.m/echo.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/module-tests/test3.m/test3.1.m/echo.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/module-tests/test4.m/echo.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/module-tests/test4.m/echo.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/module-tests/test_3.m/echo.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/module-tests/test_3.m/echo.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/module-tests/test_3.m/test_3_1.m/echo.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/module-tests/test_3.m/test_3_1.m/echo.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/xcode/aliases.zsh]  ####
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias watchos="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator\ \(Watch\).app"

#### END [/Users/coreybacon/.dotfiles/xcode/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/zsh/aliases.zsh]  ####
alias reload!='. ~/.zshrc'

alias cls='clear' # Good 'ol Clear Screen command
alias gpg2='gpg' # Good 'ol Clear Screen command

#### END [/Users/coreybacon/.dotfiles/zsh/aliases.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/zsh/config.zsh]  ####
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# this is not needed as it is autoloaded now
#fpath=($DOTFILES/functions $fpath)

autoload -U $DOTFILES/functions/*(:t)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char
# Fix for funny ALT+C
bindkey "ç" fzf-cd-widget
#### END [/Users/coreybacon/.dotfiles/zsh/config.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/zsh/fpath.zsh]  ####
#add each topic folder to fpath so that they can add functions and completion scripts
for topic_folder ($DOTFILES/*) if [ -d $topic_folder ]; then  fpath=($topic_folder $fpath); fi;

#### END [/Users/coreybacon/.dotfiles/zsh/fpath.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/zsh/prompt.zsh]  ####
autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

# This assumes that you always have an origin named `origin`, and that you only
# care about one specific origin. If this is not the case, you might want to use
# `$git cherry -v @{upstream}` instead.
need_push () {
  if [ $($git rev-parse --is-inside-work-tree 2>/dev/null) ]
  then
    number=$($git cherry -v origin/$(git symbolic-ref --short HEAD) 2>/dev/null | wc -l | bc)

    if [[ $number == 0 ]]
    then
      echo " "
    else
      echo " with %{$fg_bold[magenta]%}$number unpushed%{$reset_color%}"
    fi
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

battery_status() {
  if test ! "$(uname)" = "Darwin"
  then
    exit 0
  fi

  if [[ $(sysctl -n hw.model) == *"Book"* ]]
  then
    $DOTFILES/bin/battery-status
  fi
}

export PROMPT=$'\n$(battery_status)in $(directory_name) $(git_dirty)$(need_push)\n› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}

#### END [/Users/coreybacon/.dotfiles/zsh/prompt.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/zsh/window.zsh]  ####
# From http://dotfiles.org/~_why/.zshrc
# Sets the window title nicely no matter where you are
function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2\a" # plain xterm title ($3 for pwd)
    ;;
  esac
}


#### END [/Users/coreybacon/.dotfiles/zsh/window.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/git/completion.zsh]  ####
# Uses git's autocompletion for inner commands. Assumes an install of git's
# bash `git-completion` script at $completion below (this is where Homebrew
# tosses it, at least).
completion='$(brew --prefix)/share/zsh/site-functions/_git'

if test -f $completion
then
  source $completion
fi

#### END [/Users/coreybacon/.dotfiles/git/completion.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/hooks/completion.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/hooks/completion.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/hooks/completion.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/hooks/completion.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/zsh/completion.zsh]  ####
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# Auto expand alias
#zstyle ':completion:*' completer _expand_alias _complete _ignored

#### END [/Users/coreybacon/.dotfiles/zsh/completion.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/direnv/exit.zsh]  ####
eval "$(direnv hook zsh)"

#### END [/Users/coreybacon/.dotfiles/direnv/exit.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/hooks/exit.zsh]  ####
source "$ZSH"/oh-my-zsh.sh

#### END [/Users/coreybacon/.dotfiles/test/_module-tests/oh-my-zsh.m/hooks/exit.zsh]  ####
####  START [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/hooks/exit.zsh]  ####

#### END [/Users/coreybacon/.dotfiles/test/_module-tests/test2.m/hooks/exit.zsh]  ####
