settings_segment_separator_right=''
settings_segment_separator_left=''
settings_segment_splitter_left='  '
settings_segment_splitter_right='  '
settings_prompt_prefix_upper=''
settings_prompt_prefix_lower=''
settings_git_icon='  '

print_themed_segment() {
  local color_type=$1
  local segment_length=0
  shift
  local part_length
  local themed_segment

  if [[ "$segment_position" == 'left' ]]; then
    part_splitter="$settings_segment_splitter_left"
    seperator="$settings_segment_separator_left"
    local seperator_themed
    print_fg_color 'seperator_themed' "$primary_color"
    seperator_themed="${seperator_themed}${seperator}"
  else
    part_splitter="$settings_segment_splitter_right"
    seperator="$settings_segment_separator_right"
    local seperator_themed
    print_bg_color 'seperator_themed' "$primary_color"
    seperator_themed="${seperator_themed}${seperator}"
  fi

  local part_splitter_on
  print_fg_color 'part_splitter_on' "$splitter_color"
  local part_splitter_off
  print_fg_color 'part_splitter_off' "$secondary_color"
  local part_splitter_themed="${part_splitter_on}${part_splitter}${part_splitter_off}"
  local part_splitter_length="${#part_splitter}"
  local seperator_length="${#seperator}"

  for part in "${@}"; do
    part_length="${#part}"

    if [[ -n "$themed_segment" ]]; then
      themed_segment="${themed_segment}${part_splitter}${part}"
      segment_length=$(( segment_length + part_length + part_splitter_length ))
    else
      themed_segment="$part"
      segment_length="$part_length"
    fi
  done

  if [[ -n "${segment_value// /}" ]]; then
    segment_length=$(( segment_length + 2 ))
    segment_value=" ${segment_value} "
  fi


  local prepare_color=
  print_fg_color 'prepare_color' "$primary_color"
  segment_length=$(( segment_length + seperator_length ))
  local themed_segment_colors
  print_colors 'themed_segment_colors' "$secondary_color" "$primary_color"
  themed_segment="${seperator}${themed_segment_colors}${themed_segment}${prepare_color}"
  printf '%s;;%s' "$segment_length" "$themed_segment"
}
