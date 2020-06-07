#! /usr/bin/env bash

# shellcheck source=functions/decorate.bash
source "${sbp_path}/functions/decorate.bash"
# shellcheck source=functions/configure.bash
source "${sbp_path}/functions/configure.bash"
# shellcheck source=functions/execute.bash
source "${sbp_path}/functions/execute.bash"
# shellcheck source=functions/log.bash
source "${sbp_path}/functions/log.bash"

load_config

COLUMNS=$1
COMMAND_EXIT_CODE=$2
COMMAND_DURATION=$3

generate_prompt() {
  execute_prompt_hooks

  # Start generating segments
  # If special case is found, set state (filler, newline, prompt)
  #
  # If we've found a filler insert it

  local prompt_left="\n"
  local prompt_filler prompt_right prompt_ready segment_position
  local prompt_left_end=$(( ${#settings_segments_left[@]} - 1 ))
  local prompt_right_end=$(( ${#settings_segments_right[@]} + prompt_left_end ))
  local prompt_segments=("${settings_segments_left[@]}" "${settings_segments_right[@]}" 'prompt_ready')
  local number_of_top_segments=$(( ${#settings_segments_left[@]} + ${#settings_segments_right[@]} - 1))
  local segment_max_length=$(( COLUMNS / number_of_top_segments ))

  local settings_segments_new=('newline' ${settings_segments_left[@]} 'filler' ${settings_segments_right[@]} 'newline' 'prompt_ready')

  declare -A pid_left
  declare -A pid_right
  declare -A pid_two

  # Concurrent evaluation of promt segments
  tempdir=$_sbp_cache

  declare -a segment_list
  declare -a fillers
  declare -a newlines

  local segment_position='left'
  local last_newline=0

  for i in "${!settings_segments_new[@]}"; do
    segment_name="${settings_segments_new[i]}"

    case "$segment_name" in
      'newline')
        newlines+=("$i")
        segment_position='left'
        last_newline=$i
        pids[i]=0
        ;;
      'filler')
        fillers+=("$i")
        segment_position='right'
        pids[i]=0
        ;;
      *)
        generate_segment "$segment_name" "$segment_position" "$segment_max_length" "$(( i - last_newline ))" > "${tempdir}/${i}" & pids[i]=$!
        ;;
    esac
  done

  total_empty_space="$COLUMNS"
  declare -a completed_segments
  local pre_filler=
  local post_filler=

  for i in "${!pids[@]}"; do
    if [[ "${fillers[0]}" -eq "$i" ]]; then
      current_filler_position="$i"
      fillers=("${fillers[@]:1}")
    elif [[ ${newlines[0]} -eq "$i" ]]; then
      newlines=("${newlines[@]:1}")
      local filler
      if [[ -n "$current_filler_position" ]]; then
        print_themed_filler 'filler' "$total_empty_space"
        total_empty_space="$COLUMNS"
        pre_filler="${pre_filler}${filler}${post_filler}"
        unset current_filler_position post_filler
      fi

      pre_filler="${pre_filler}\n"
    else
      wait "${pids[i]}"
      segment_output=$(<"$tempdir/$i")
      segment=${segment_output##*;;}
      segment_length=${segment_output%;;*}
      # Make fillers and newlines part of the theme?
      empty_space=$(( total_empty_space - segment_length ))

      if [[ "$empty_space" -gt 0 ]]; then
        if [[ -n "$current_filler_position" ]]; then
          post_filler="${post_filler}${segment}"
        else
          pre_filler="${pre_filler}${segment}"
        fi
        total_empty_space="$empty_space"
        filler_space=
      fi
    fi
  done
  prompt="${pre_filler}${post_filler}"


  # Print the prompt and reset colors
  printf '%s' "$prompt"
}

generate_prompt
