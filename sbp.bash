#! /usr/bin/env bash

#################################
#   Simple Bash Prompt (SBP)    #
#################################

export sbp_path
# shellcheck source=functions/log.bash
source "${sbp_path}/functions/log.bash"
# shellcheck source=functions/interact.bash
source "${sbp_path}/functions/interact.bash"

_sbp_cache="/tmp/sbp.${BASHPID}.cache"

if [[ "$OSTYPE" == "darwin"* ]]; then
  export date_cmd='gdate'
else
  export date_cmd='date'
fi

SHELL_BIRTH=$(( $(date +'%s') - SECONDS ))
export SHELL_BIRTH

_sbp_timer_start() {
  timer_start=$("$date_cmd" +'%s%3N')
}

_sbp_timer_tick() {
  timer_stop=$("$date_cmd" +'%s%3N')
  timer_spent=$(( timer_stop - timer_start))
  >&2 echo "${timer_spent}ms: $1"
  timer_start=$("$date_cmd" +'%s%3N')
}

export -f _sbp_timer_start
export -f _sbp_timer_tick

options_file=$(sbp extra_options)
if [[ -f "$options_file" ]]; then
  source "$options_file"
fi

#trap 'printf "\e[0n"' WINCH

_sbp_set_prompt() {
  local command_status=$?
  local sbp_cache=$1
  local command_status sbp_cache current_time command_start command_duration
  [[ -n "$SBP_DEBUG" ]] && _sbp_timer_start
  current_time=$(date +%s)
  if [[ -f "$sbp_cache" ]]; then
    command_start=$(< "$sbp_cache")
    command_duration=$(( current_time - command_start ))
  else
    command_duration=0
  fi

  # TODO move this somewhere else
  title="${PWD##*/}"
  if [[ -n "$SSH_CLIENT" ]]; then
    title="${HOSTNAME:-ssh}:${title}"
  fi
  printf '\e]2;%s\007' "$title"

  PS1=$(bash "${sbp_path}/functions/generate.bash" "$COLUMNS" "$command_status" "$command_duration")
  [[ -n "$SBP_DEBUG" ]] && _sbp_timer_tick "Done"

}


_sbp_pre_exec() {
  local sbp_cache=$1
  date +%s > "$sbp_cache"
}

PS0="\$(_sbp_pre_exec $_sbp_cache)"

[[ "$PROMPT_COMMAND" =~ _sbp_set_prompt ]] || PROMPT_COMMAND="_sbp_set_prompt "$_sbp_cache";$PROMPT_COMMAND"
