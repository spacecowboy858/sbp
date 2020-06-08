#! /usr/bin/env bash

segments:exit_code() {
  local return_code=$1
  if [[ -z "$return_code" ]]; then
    return_code=0
  fi

  if [[ "$return_code" -ne 0 && "$return_code" -ne 130 ]]; then
    print_themed_segment 'normal' "$return_code"
  fi
}
