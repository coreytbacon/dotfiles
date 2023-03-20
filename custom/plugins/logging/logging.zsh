#!/usr/bin/env zsh
PLUGIN_DIR=$(dirname "$0")

# Script log
SCRIPT_LOG_PATH="$HOME/.logs"
SCRIPT_LOG_FILE="zsh-logging.log"

# Scripts log
SCRIPT_LOG=${SCRIPT_LOG_PATH}/${SCRIPT_LOG_FILE}
# Make directory and log file
mkdir -p "${SCRIPT_LOG_PATH}"
touch ${SCRIPT_LOG_PATH}/${SCRIPT_LOG_FILE}

log:scriptentry() {
  SCRIPT_NAME=$(basename "$0")
  SCRIPT_NAME="${SCRIPT_NAME%.*}"
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;35;40m[DEBUG]\e[0m \e[1;30;40m> $SCRIPT_NAME ${funcstack[0]}\e[0m" | tee -a "$SCRIPT_LOG"
}

log:scriptexit() {
  SCRIPT_NAME=$(basename "$0")
  SCRIPT_NAME="${SCRIPT_NAME%.*}"
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;35;40m[DEBUG]\e[0m \e[1;30;40m< $SCRIPT_NAME ${funcstack[0]}\e[0m" | tee -a "$SCRIPT_LOG"
}
log:entry() {
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;35;40m[DEBUG]\e[0m \e[1;30;40m> ${funcstack[2]}\e[0m" | tee -a "$SCRIPT_LOG"
}

log:exit() {
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;35;40m[DEBUG]\e[0m \e[1;30;40m< ${funcstack[2]}\e[0m" | tee -a "$SCRIPT_LOG"
}

log:info() {
  local function_name="${FUNCNAME[1]}"
  local msg="$1"

  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;34;40m[INFO]\e[0m    $msg" | tee -a "$SCRIPT_LOG"
}

log:success() {
  local function_name="${FUNCNAME[1]}"
  local msg="$1"

  echo -e "\e[1;30;40m[$(date)]\e[0m \e[3;32;40m[SUCCESS]\e[0m $msg" | tee -a "$SCRIPT_LOG"
}

log:warn() {
  local function_name="${FUNCNAME[1]}"
  local msg="$1"

  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;33;40m[WARN]\e[0m    $msg" | tee -a "$SCRIPT_LOG"
}

log:debug() {
  local function_name="${FUNCNAME[1]}"
  local msg="$1"

  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;35;40m[DEBUG]\e[0m   $msg" | tee -a "$SCRIPT_LOG"
}

log:error() {
  local function_name="${FUNCNAME[1]}"
  local msg="$1"

  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;31;40m[ERROR]\e[0m   $msg" | tee -a "$SCRIPT_LOG"
}
