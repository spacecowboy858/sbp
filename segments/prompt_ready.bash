#! /usr/bin/env bash

segments::prompt_ready() {
  if [[ "$SETTINGS_PROMPT_READY_VI_MODE" -eq 1 ]]; then
    return 0
  fi

  print_themed_segment 'normal' "$SETTINGS_PROMPT_READY_ICON"

}
