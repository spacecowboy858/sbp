#! /usr/bin/env bash

segment_generate_host() {
  local segment_direction=$3

  if [[ -n "$SSH_CLIENT" ]]; then
    host_value="${USER}@${HOSTNAME}"
  else
    host_value="$USER"
  fi

  printf '%s' "$host_value"

  if [[ "$(id -u)" -eq 0 ]]; then
    return 3
  fi

}
