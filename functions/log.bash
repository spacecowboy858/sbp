#! /usr/bin/env bash

log::error() {
  local context="${BASH_SOURCE[1]}:${FUNCNAME[1]}"
  >&2 printf '%s: \e[38;5;196m%s\e[00m\n' "${context}" "${*}"
}

log::info() {
  local context="${BASH_SOURCE[1]}:${FUNCNAME[1]}"
  >&2 printf '%s: \e[38;5;76m%s\e[00m\n' "${context}" "${*}"
}
