settings_segment_separator_right=''
settings_segment_separator_left=''
settings_segment_splitter_left=''
settings_segment_splitter_right=''
settings_segment_separator_right=''
settings_segment_separator_left=''
settings_prompt_prefix_upper=''
settings_prompt_prefix_lower=''
settings_git_icon=''
settings_git_incoming_icon='out:'
settings_git_outgoing_icon='in:'
settings_path_splitter_disable=1
settings_timestamp_format="%H:%M:%S"
settings_openshift_default_user="$USER"
settings_rescuetime_refresh_rate=600
settings_segment_enable_bg_color=0
settings_git_icon=' '

print_themed_segment() {
  local primary_color=$1
  local secondary_color=$2
  local segment_value=$3
  local segment_length=$5

  if [[ -n "${segment_value// /}" ]]; then
    segment_length=$(( segment_length + 2 ))
    segment_value=" ${segment_value} "
  fi

  secondary_color="$primary_color"
  primary_color=""
  color="$(print_fg_color "$secondary_color")"

  full_output="${color}${segment_value}"

  printf '%s;;%s' "$segment_length" "$full_output"
}
