#!/usr/bin/env bash

segment_generate_rescuetime() {
  local cache_file="${cache_folder}/rescuetime.csv"

  if [[ -f "$cache_file" ]]; then
    cache=$(<"$cache_file")
    pulse="${cache/;*}"
    time="${cache/*;}"
  else
    exit 0
  fi

  print_themed_segment 'normal' "$pulse" "$time"

}
