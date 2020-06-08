#! /usr/bin/env bash

segments::path_ro() {
  if [[ ! -w "$PWD" ]] ; then
    segment_value=""
    print_themed_segment 'normal' "$segment_value"
  fi
}
