#! /usr/bin/env bash

segment_generate_python_env() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    segment_value="${VIRTUAL_ENV##*/}"
  else
    path=${PWD}
    while [[ $path ]]; do
      if [[ -f "${path}/.python-version" ]]; then
        segment_value=$(< "${path}/.python-version")
        break
      fi
      path=${path%/*}
    done
  fi

  if [[ -n "$segment_value" ]]; then
    print_themed_segment 'normal' "$segment_value"
  fi
}
