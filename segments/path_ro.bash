#! /usr/bin/env bash

segment_generate_path_ro() {
  if [[ ! -w "$PWD" ]] ; then
    segment_value=""
    print_themed_segment 'normal' "$segment_value"
  fi
}
