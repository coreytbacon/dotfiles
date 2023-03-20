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
