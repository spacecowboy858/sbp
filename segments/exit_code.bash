#! /usr/bin/env bash

segment_generate_exit_code() {
  local segment_direction=$3
  local return_code=$1
  if [[ -z "$return_code" ]]; then
    return_code=0
  fi

  if [[ "$return_code" -ne 0 && "$return_code" -ne 130 ]]; then
    local segment_value="${return_code}"
    pretty_print_segment "$settings_return_code_color_primary" "$settings_return_code_color_secondary" " ${segment_value} " "$segment_direction"
  fi
}
