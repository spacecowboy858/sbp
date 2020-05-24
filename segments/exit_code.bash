#! /usr/bin/env bash

segment_generate_exit_code() {
  local return_code=$1
  if [[ -z "$return_code" ]]; then
    return_code=0
  fi

  if [[ "$return_code" -ne 0 && "$return_code" -ne 130 ]]; then
    printf '%s' "$return_code"
    return 3
  fi
}
