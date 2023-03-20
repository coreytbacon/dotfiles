#!/bin/zsh


# Prefix for all functions
FUNCTION_PREFIX_SEPERATOR=":"
FUNCTION_PREFIX="log${FUNCTION_PREFIX_SEPERATOR}"

${FUNCTION_PREFIX}"info" () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

${FUNCTION_PREFIX}"user" () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

${FUNCTION_PREFIX}"success" () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

${FUNCTION_PREFIX}"errorne" () {
  echo ''
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
}

${FUNCTION_PREFIX}"error" () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

${FUNCTION_PREFIX}"fail" () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}