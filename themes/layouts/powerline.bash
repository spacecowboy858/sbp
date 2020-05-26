settings_segment_separator_right=''
settings_segment_separator_left=''
settings_segment_splitter_left=''
settings_segment_splitter_right=''
settings_prompt_prefix_upper=''
settings_prompt_prefix_lower=''
settings_git_icon=''

print_themed_segment() {
  local primary_color=$1
  local secondary_color=$2
  local segment_value=$3
  local position=$4
  local segment_length=$5

  if [[ -n "${segment_value// /}" ]]; then
    segment_length=$(( segment_length + 2 ))
    segment_value=" ${segment_value} "
  fi


  [[ -z "$segment_value" ]] && return 0

  prepare_color="$(print_fg_color "$primary_color")"
  case $position in
    right)
      seperator="$(print_bg_color "$primary_color")${settings_segment_separator_right}"
      segment_length=$(( segment_length + 1 ))
    ;;
    left)
      seperator="$(print_fg_color "$primary_color")${settings_segment_separator_left}"
      segment_length=$(( segment_length + 1 ))
    ;;
  esac
  segment="$(print_colors "$secondary_color" "$primary_color")${segment_value}"
  full_output="${seperator}${segment}${prepare_color}"
  printf '%s;;%s' "$segment_length" "$full_output"
}
