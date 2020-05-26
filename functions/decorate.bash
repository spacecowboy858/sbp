#! /usr/bin/env bash

export colors_ids=( 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F )

get_complement_rgb() {
  input_colors=()
  output_colors=()

  if [[ -z "${1//[0123456789]}" ]]; then
    # This is not accurate
    printf '%s' "$(( 255 - $1 ))"
  else
    mapfile -t input_colors < <(tr ';' '\n' <<< "$1")
    for color_value in "${input_colors[@]}"; do
      output_colors+=("$(( 255 - color_value ))")
    done

    printf '%s;%s;%s' "${output_colors[0]}" "${output_colors[1]}" "${output_colors[2]}"
  fi
}

print_colors() { # prints ansi escape codes for fg and bg (optional)
  local fg_code=$1
  local bg_code=$2

  printf '%s%s' "$(print_fg_color "$fg_code")" "$(print_bg_color "$bg_code")"
}

print_bg_color() {
  local bg_code=$1
  local escaped=$2

  if [[ -z "$bg_code" ]]; then
    bg_escaped="\e[49m"
  elif [[ -z "${bg_code//[0123456789]}" ]]; then
    bg_escaped="\e[48;5;${bg_code}m"
  else
    bg_escaped="\e[48;2;${bg_code}m"
  fi

  if [[ -z "$escaped" ]]; then
    printf '\[%s\]' "${bg_escaped}"
  else
    printf '%s' "${bg_escaped}"
  fi
}

print_fg_color() {
  local fg_code=$1
  local escaped=$2

  if [[ -z "$fg_code" ]]; then
    fg_escaped="\e[39m"
  elif [[ -z "${fg_code//[0123456789]}" ]]; then
    fg_escaped="\e[38;5;${fg_code}m"
  else
    fg_escaped="\e[38;2;${fg_code}m"
  fi

  if [[ -z "$escaped" ]]; then
    printf '\[%s\]' "${fg_escaped}"
  else
    printf '%s' "${fg_escaped}"
  fi
}

pretty_print_splitter() {
  local primary_color=$1
  local secondary_color=$2
  local splitter_color=$3
  local direction=$4

  if [[ "$direction" == 'right' ]]; then
    splitter_character="$settings_segment_splitter_right"
  else
    splitter_character="$settings_segment_splitter_left"
  fi

  if [[ "$settings_segment_enable_bg_color" -eq 0 ]]; then
    segment_color="$primary_color"
  else
    segment_color="$secondary_color"
  fi

  splitter_on_color=$(print_fg_color "$splitter_color")
  splitter_off_color=$(print_fg_color "$segment_color")
  printf '%s' "${splitter_on_color}${splitter_character}${splitter_off_color}"
}

generate_segment() {
  local segment=$1
  local segment_position=$2
  local segment_max_length=$3
  local segment_script="$(get_executable_script 'segment' "$segment")"

  if [[ -n "$segment_script" ]]; then
    source "$segment_script"

    segment_splitter="$settings_segment_splitter_right"
    if [[ "$segment_position" == 'left' ]]; then
      segment_splitter="$settings_segment_splitter_left"
    fi

    segment_result="$("segment_generate_${segment}" "$command_exit_code" "$command_time" "$segment_max_length")"
    segment_exit_code=$?
    segment_length=${#segment_result}
    [[ "$segment_exit_code" -eq 1 || -z "${segment_result// /}" ]] && return 1

    primary_color_var="settings_${segment}_color_primary"
    secondary_color_var="settings_${segment}_color_secondary"

    if [[ "$segment_exit_code" -eq 3 ]]; then
      primary_color_var="${primary_color_var}_highlight"
      secondary_color_var="${secondary_color_var}_highlight"
    fi

    primary_color="${!primary_color_var}"
    secondary_color="${!secondary_color_var}"

    print_themed_segment "$primary_color" "$secondary_color" "$segment_result" "$segment_position" "$segment_length"
  fi
}

pretty_print_seperator() {
  local to_color=$1
  local direction=$2

  case $direction in
    right)
      printf '%s' "$(print_bg_color "$to_color")${settings_segment_separator_right}"
    ;;
    left)
      printf '%s' "$(print_fg_color "$to_color")${settings_segment_separator_left}"
      ;;
  esac
}
