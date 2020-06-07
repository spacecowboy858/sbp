#!/usr/bin/env bash

get_executable_script() {
  local -n return_value=$1
  local type=$2
  local feature=$3

  if [[ -f "${config_folder}/peekaboo/${segment_name}" ]]; then
    return 0
  fi

  local local_script="${config_folder}/${type}s/${feature}.bash"
  local global_script="${sbp_path}/${type}s/${feature}.bash"

  if [[ -x "$local_script" ]]; then
    return_value="$local_script"
  elif [[ -x "$global_script" ]]; then
    return_value="$global_script"
  else
    log_error "Could not find $local_script"
    log_error "Could not find $global_script"
    log_error "Make sure it exists"
  fi
}

execute_prompt_hooks() {
  local hook_script
  for hook in "${settings_hooks[@]}"; do
    get_executable_script 'hook_script' 'hook' "$hook"

    if [[ -n "$hook_script" ]]; then
      (source "$hook_script" && nohup hook_execute_"$hook" "$COMMAND_EXIT_CODE" "$COMMAND_DURATION" &>/dev/null &)
    fi
  done
}

generate_segment() {
local segment=$1
local SEGMENT_POSITION=$2
local SEGMENT_MAX_LENGTH=$3
local SEGMENT_LINE_POSITION=$4

local segment_script
get_executable_script 'segment_script' 'segment' "$segment"

if [[ -n "$segment_script" ]]; then
  source "$segment_script"

  local primary_color_var="settings_${segment}_color_primary"
  local secondary_color_var="settings_${segment}_color_secondary"

  local primary_color_highlight_var="${primary_color_var}_highlight"
  local secondary_color_highlight_var="${secondary_color_var}_highlight"

  PRIMARY_COLOR="${!primary_color_var}"
  SECONDARY_COLOR="${!secondary_color_var}"

  local primary_color_highlight="${!primary_color_highlight_var}"
  SECONDARY_COLOR_HIGHLIGHT="${!secondary_color_highlight_var}"

  local splitter_color_var="settings_${segment}_splitter_color"
  SPLITTER_COLOR="${!splitter_color_var}"

  "segment_generate_${segment}" "$COMMAND_EXIT_CODE" "$COMMAND_DURATION" "$SEGMENT_MAX_LENGTH"

fi

}
