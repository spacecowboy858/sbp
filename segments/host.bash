#! /usr/bin/env bash

segment_generate_host() {

  if [[ -n "$SSH_CLIENT" ]]; then
    host_value="${USER}@${HOSTNAME}"
  else
    host_value="$USER"
  fi

  if [[ "$(id -u)" -eq 0 ]]; then
    return 3
    print_themed_segment 'highlight' "$host_value"
  else
    print_themed_segment 'normal' "$host_value"
  fi

}
