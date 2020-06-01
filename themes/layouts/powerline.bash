settings_segment_separator_right=''
settings_segment_separator_left=''
settings_segment_splitter_left=''
settings_segment_splitter_right=''
settings_prompt_prefix_upper=''
settings_prompt_prefix_lower=''
settings_git_icon='  '

print_themed_segment() {
  local color_type=$1
  local segment_length=0
  shift
  local part_length
  local themed_segment
  local seperator_themed
  local part_splitter

  if [[ "$color_type" == 'highlight' ]]; then
    primary_color="$primary_color_highlight"
    secondary_color="$secondary_color_highlight"
  fi

  if [[ "$segment_position" == 'left' ]]; then
    part_splitter=" $settings_segment_splitter_left "
    seperator="$settings_segment_separator_left"
    local seperator_color
    print_fg_color 'seperator_color' "$primary_color"
    seperator_themed="${seperator_color}${seperator}"
  elif [[ "$segment_position" == 'right' ]]; then
    part_splitter=" $settings_segment_splitter_right "
    seperator="$settings_segment_separator_right"
    local seperator_color
    print_bg_color 'seperator_color' "$primary_color"
    seperator_themed="${seperator_color}${seperator}"
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


  if [[ -n "${themed_segment// /}" ]]; then
    segment_length=$(( segment_length + 2 ))
    themed_segment=" ${themed_segment} "
  fi


  local prepare_color=
  print_fg_color 'prepare_color' "$primary_color"
  segment_length=$(( segment_length + seperator_length ))
  local themed_segment_colors
  print_colors 'themed_segment_colors' "$secondary_color" "$primary_color"
  themed_segment="${seperator_themed}${themed_segment_colors}${themed_segment}${prepare_color}"
  printf '%s;;%s' "$segment_length" "$themed_segment"
}
