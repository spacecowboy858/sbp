#! /usr/bin/env bash

segment_generate_command() {
  local command_exit_code=$1
  local command_time=$2
  local timer_m=0
  local timer_s=0

  if [[ "$command_exit_code" -lt 0 || "$command_exit_code" -eq 130 ]]; then
    command_time=0
  fi

  if [[ "$command_time" -gt 0 ]]; then
    timer_m=$(( command_time / 60 ))
    timer_s=$(( command_time % 60 ))
  fi

  command_value="last: ${timer_m}m ${timer_s}s"


  if [[ "$command_exit_code" -gt 0 && "$command_exit_code" -ne 130 ]]; then
    print_themed_segment 'normal' "$command_value"
  else
    print_themed_segment 'highlight' "$command_value"
  fi

}
