#! /usr/bin/env bash

segment_generate_timestamp() {
  local segment_direction=$3
  local timestamp_value=$(date +"$settings_timestamp_format")
  pretty_print_segment "$settings_timestamp_color_primary" "$settings_timestamp_color_secondary" " ${timestamp_value} " "$segment_direction"
}
