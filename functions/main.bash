#! /usr/bin/env bash

# shellcheck source=functions/decorate.bash
source "${sbp_path}/functions/decorate.bash"
# shellcheck source=functions/configure.bash
source "${sbp_path}/functions/configure.bash"
# shellcheck source=functions/execute.bash
source "${sbp_path}/functions/execute.bash"

load_config

COLUMNS=$1
COMMAND_EXIT_CODE=$2
COMMAND_DURATION=$3

generate_prompt() {
  execute_prompt_hooks

  local prompt_left="\n"
  local prompt_filler prompt_right prompt_ready segment_position
  local prompt_left_end=$(( ${#settings_segments_left[@]} - 1 ))
  local prompt_right_end=$(( ${#settings_segments_right[@]} + prompt_left_end ))
  local prompt_segments=("${settings_segments_left[@]}" "${settings_segments_right[@]}" 'prompt_ready')
  local number_of_top_segments=$(( ${#settings_segments_left[@]} + ${#settings_segments_right[@]} - 1))
  local segment_max_length=$(( COLUMNS / number_of_top_segments ))

  declare -A pid_left
  declare -A pid_right
  declare -A pid_two

  # Concurrent evaluation of promt segments
  tempdir=$_sbp_cache

  for i in "${!prompt_segments[@]}"; do
    segment_name="${prompt_segments[i]}"
    [[ -z "$segment_name" ]] && continue
    if [[ "$i" -eq 0 ]]; then
      segment_position=''
      pid_left["$i"]="$i"
    elif [[ "$i" -le "$prompt_left_end" ]]; then
      segment_position='right'
      pid_left["$i"]="$i"
    elif [[ "$i" -le "$prompt_right_end" ]]; then
      segment_position='left'
      pid_right["$i"]="$i"
    elif [[ "$i" -gt "$prompt_right_end" && -z "$pid_two" ]]; then
      segment_position='line2'
      pid_two["$i"]="$i"
    fi

    generate_segment "$segment_name" "$segment_position" "$segment_max_length" > "${tempdir}/${i}" & pids[i]=$!

  done


  total_empty_space="$COLUMNS"

  if [[ -n "${settings_prompt_prefix_upper}" ]]; then
    local prefix_color
    total_empty_space=$(( total_empty_space - ${#settings_prompt_prefix_upper} - 1 ))
    print_fg_color 'prefix_color' "$settings_prompt_ready_color_primary"
    prompt_left="${prompt_left} ${prefix_color}${settings_prompt_prefix_upper}"
  fi

  for i in "${!pids[@]}"; do
    wait "${pids[i]}"
    segment_output=$(<"$tempdir/$i")
    segment=${segment_output##*;;}
    segment_length=${segment_output%;;*}
    empty_space=$(( total_empty_space - segment_length ))

    if [[ -n "${pid_left["$i"]}"  && "$empty_space" -gt 0 ]]; then
      prompt_left="${prompt_left}${segment}"
      total_empty_space="$empty_space"
    elif [[ -n "${pid_right["$i"]}" && "$empty_space" -gt 0  ]]; then
      prompt_right="${prompt_right}${segment}"
      total_empty_space="$empty_space"
    elif [[ -n "${pid_two["$i"]}" ]]; then
      prompt_ready="${segment}"
    fi
  done

  # Generate the filler segment
  if [[ -n "$prompt_right" ]]; then
    prompt_uncolored="$(( total_empty_space - 1 ))" # Account for the filler seperator
  else
    prompt_uncolored=1
  fi
  padding=$(printf "%*s" "$prompt_uncolored")
  segment_position='right'
  prompt_filler_output="$(print_themed_segment 'normal' "$padding")"
  prompt_filler=${prompt_filler_output##*;;}


  if [[ "${settings_prompt_ready_newline}" -eq 1 ]]; then
    prompt_ready="\n${prompt_ready}"
  fi


  # Print the prompt and reset colors
  printf '%s' "${prompt_left}${prompt_filler}${prompt_right}${color_reset}${prompt_ready}${color_reset}"
}

generate_prompt
