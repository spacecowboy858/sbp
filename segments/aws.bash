#! /usr/bin/env bash

segment_generate_aws() {
  if [[ -n "$AWS_DEFAULT_PROFILE" ]]; then
    printf '%s' "$AWS_DEFAULT_PROFILE"
  fi
}
