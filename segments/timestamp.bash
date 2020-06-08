#! /usr/bin/env bash

segments::timestamp() {
  local timestamp_value=$(date +"$SETTINGS_TIMESTAMP_FORMAT")
  print_themed_segment 'normal' "$timestamp_value"
}
