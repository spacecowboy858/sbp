#! /usr/bin/env bash

segment_generate_timestamp() {
  local timestamp_value=$(date +"$settings_timestamp_format")
  print_themed_segment 'normal' "$timestamp_value"
}
