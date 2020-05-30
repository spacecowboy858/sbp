#! /usr/bin/env bash

segment_generate_aws() {
  if [[ -n "$AWS_DEFAULT_PROFILE" ]]; then
    print_themed_segment 'normal' "$AWS_DEFAULT_PROFILE"
  fi
}
