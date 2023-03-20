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