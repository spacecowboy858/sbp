#! /usr/bin/env bash

segment_generate_prompt_ready() {
  if [[ "$settings_prompt_ready_vi_mode" -eq 1 ]]; then
    return 0
  fi

  print_themed_segment 'normal' "$settings_prompt_ready_icon"

}
