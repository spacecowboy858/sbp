#! /usr/bin/env bash

debug::log_error() {
  local context="${BASH_SOURCE[1]}:${FUNCNAME[1]}"
  >&2 printf '%s: \e[38;5;196m%s\e[00m\n' "${context}" "${*}"
}

debug::log_info() {
  local context="${BASH_SOURCE[1]}:${FUNCNAME[1]}"
  >&2 printf '%s: \e[38;5;76m%s\e[00m\n' "${context}" "${*}"
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  export date_cmd='gdate'
else
  export date_cmd='date'
fi

debug::start_timer() {
  timer_start=$("$date_cmd" +'%s%3N')
}

debug::tick_timer() {
  timer_stop=$("$date_cmd" +'%s%3N')
  timer_spent=$(( timer_stop - timer_start))
  >&2 echo "${timer_spent}ms: $1"
  timer_start=$("$date_cmd" +'%s%3N')
}

