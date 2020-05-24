settings_segment_separator_right='['
settings_segment_separator_left=']'
settings_segment_splitter_left='-'
settings_segment_splitter_right='-'
settings_prompt_prefix_upper='┍'
settings_prompt_prefix_lower='└'
settings_prompt_ready_icon="${settings_prompt_prefix_lower}${settings_prompt_ready_icon}"
settings_segment_enable_bg_color=0
settings_path_splitter_disable=1
settings_prompt_ready_newline=1

print_themed_segment() {
  local primary_color=$1
  local secondary_color=$2
  local segment_value=$3
  local direction=$4
  local segment_length=$5

  [[ -z "$segment_value" ]] && return 0

  secondary_color="$primary_color"
  primary_color=""
  color="$(print_fg_color "$secondary_color")"

  if [[ -z "${segment_value// /}" ]]; then
    full_output="${color}${segment_value}"
  else
    full_output="${color}${settings_segment_separator_right}${segment_value}${settings_segment_separator_left}"
    segment_length=$(( segment_length + 2 ))
  fi

  printf '%s;;%s' "$segment_length" "$full_output"
}

