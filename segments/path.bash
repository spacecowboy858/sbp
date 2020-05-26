#! /usr/bin/env bash

segment_generate_path() {
  local segment_max_length=$4

  local path_value=
  local wdir=${PWD/${HOME}/\~}

  if [[ "${#wdir}" -gt "$segment_max_length" ]]; then
    folder=${wdir##*/}
    IFS='/' wdir=$(for p in ${wdir}; do printf '%s/' "${p:0:1}"; done;)
    wdir="${wdir%/*}${folder:1}"
  fi

  IFS=/ read -r -a wdir_array <<<"${wdir}"
  if [[ $settings_path_splitter_disable -ne 1 && "${#wdir_array[@]}" -gt 1 ]]; then
    for i in "${!wdir_array[@]}"; do
      dir=${wdir_array["$i"]}
      if [[ -n "$dir" ]]; then
        segment_value=" ${dir} "
        [[ "$(( i + 1 ))" -eq "${#wdir_array[@]}" ]] && unset segment_splitter
        path_value="${path_value}${segment_value}${segment_splitter}"
      fi
    done
  else
    path_value="$wdir"
  fi

  printf '%s' "$path_value"
}
