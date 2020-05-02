#! /usr/bin/env bash

segment_generate_command() {
  local command_exit_code=$1
  local command_time=$2
  local segment_direction=$3
  local timer_m=0
  local timer_s=0

  if [[ "$command_exit_code" -lt 0 || "$command_exit_code" -eq 130 ]]; then
    command_time=0
  fi

  if [[ "$command_exit_code" -le 0 || "$command_exit_code" -eq 130 ]]; then
    command_color_secondary="$settings_command_color_secondary"
    command_color_primary="$settings_command_color_primary"
  else
    command_color_secondary="$settings_command_color_secondary_error"
    command_color_primary="$settings_command_color_primary_error"
  fi

  if [[ "$command_time" -gt 0 ]]; then
    timer_m=$(( command_time / 60 ))
    timer_s=$(( command_time % 60 ))
  fi

  command_value="last: ${timer_m}m ${timer_s}s"

  pretty_print_segment "$command_color_primary" "$command_color_secondary" " ${command_value} " "$segment_direction"
}
