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
local segment_position=$2
local segment_max_length=$3
local segment_script

get_executable_script 'segment_script' 'segment' "$segment"

if [[ -n "$segment_script" ]]; then
  source "$segment_script"

  primary_color_var="settings_${segment}_color_primary"
  secondary_color_var="settings_${segment}_color_secondary"

  primary_color_highlight_var="${primary_color_var}_highlight"
  secondary_color_highlight_var="${secondary_color_var}_highlight"

  primary_color="${!primary_color_var}"
  secondary_color="${!secondary_color_var}"

  export primary_color_highlight="${!primary_color_highlight_var}"
  export secondary_color_highlight="${!secondary_color_highlight_var}"

  splitter_color_var="settings_${segment}_splitter_color"
  export splitter_color="${!splitter_color_var}"

  "segment_generate_${segment}" "$COMMAND_EXIT_CODE" "$COMMAND_DURATION" "$segment_max_length"

fi

}
