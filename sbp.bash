#! /usr/bin/env bash

#################################
#   Simple Bash Prompt (SBP)    #
#################################

# shellcheck source=functions/interact.bash
source "${SBP_PATH}/functions/interact.bash"
# shellcheck source=functions/debug.bash
source "${SBP_PATH}/functions/debug.bash"

if [[ -d "/run/user/${UID}" ]]; then
  _SBP_CACHE=$(mktemp -d --tmpdir="/run/user/${UID}") && trap 'rm -rf "$_SBP_CACHE"' EXIT;
else
  _SBP_CACHE=$(mktemp -d) && trap 'rm -rf "$_SBP_CACHE"' EXIT;
fi

export _SBP_CACHE
export SBP_PATH
export COLUMNS

options_file=$(sbp extra_options)
if [[ -f "$options_file" ]]; then
  source "$options_file"
fi

_sbp_set_prompt() {
  local command_status=$?
  local command_status current_time command_start command_duration
  [[ -n "$SBP_DEBUG" ]] && debug::start_timer
  current_time=$(date +%s)
  if [[ -f "${_SBP_CACHE}/execution" ]]; then
    command_start=$(< "${_SBP_CACHE}/execution")
    command_duration=$(( current_time - command_start ))
    rm "${_SBP_CACHE}/execution"
  else
    command_duration=0
  fi

  # TODO move this somewhere else
  title="${PWD##*/}"
  if [[ -n "$SSH_CLIENT" ]]; then
    title="${HOSTNAME:-ssh}:${title}"
  fi
  printf '\e]2;%s\007' "$title"

  PS1=$(bash "${SBP_PATH}/functions/main.bash" "$command_status" "$command_duration")
  [[ -n "$SBP_DEBUG" ]] && debug::tick_timer "Done"

}

_sbp_pre_exec() {
  date +%s > "${_SBP_CACHE}/execution"
}

PS0="\$(_sbp_pre_exec)"

[[ "$PROMPT_COMMAND" =~ _sbp_set_prompt ]] || PROMPT_COMMAND="_sbp_set_prompt;$PROMPT_COMMAND"
