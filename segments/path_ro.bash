#! /usr/bin/env bash

segment_generate_path_ro() {
  if [[ ! -w "$PWD" ]] ; then
    segment_value=""
    printf '%s' "$segment_value"
  fi
}
