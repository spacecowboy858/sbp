#! /usr/bin/env bash

::error() {
  local context="${BASH_SOURCE[1]}:${FUNCNAME[1]}"
  >&2 printf '%s: \e[38;5;196m%s\e[00m\n' "${context}" "${*}"
}

log::info() {
  local context="${BASH_SOURCE[1]}:${FUNCNAME[1]}"
  >&2 printf '%s: \e[38;5;76m%s\e[00m\n' "${context}" "${*}"
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  export date_cmd='gdate'
else
  export date_cmd='date'
fi

_sbp_timer_start() {
  timer_start=$("$date_cmd" +'%s%3N')
}

_sbp_timer_tick() {
  timer_stop=$("$date_cmd" +'%s%3N')
  timer_spent=$(( timer_stop - timer_start))
  >&2 echo "${timer_spent}ms: $1"
  timer_start=$("$date_cmd" +'%s%3N')
}

