settings_segment_separator_left=''
settings_segment_separator_right=''
settings_segment_splitter_left=''
settings_segment_splitter_right=''
settings_prompt_prefix_upper=''
settings_prompt_prefix_lower=''
settings_git_icon='  '

print_themed_filler() {
  local -n return_value=$1
  local seperator_size=${#settings_segment_separator_left}
  # Account for seperator and padding
  local filler_size=$(( $2 - seperator_size - 2 ))
  padding=$(printf "%*s" "$filler_size")
  SEGMENT_POSITION='left'
  SEGMENT_LINE_POSITION=2
  prompt_filler_output="$(print_themed_segment 'normal' "$padding")"
  return_value=${prompt_filler_output##*;;}
}

print_themed_segment() {
  local color_type=$1
  shift
  local segment_length=0
  local part_length=0
  local themed_segment
  local seperator_themed
  local part_splitter

  if [[ "$color_type" == 'highlight' ]]; then
    PRIMARY_COLOR="$PRIMARY_COLOR_HIGHLIGHT"
    SECONDARY_COLOR="$SECONDARY_COLOR_HIGHLIGHT"
  fi

  if [[ "$SEGMENT_POSITION" == 'left' ]]; then
    part_splitter=" $settings_segment_splitter_left "
    seperator="$settings_segment_separator_left"
    local seperator_color
    decorate::print_bg_color 'seperator_color' "$PRIMARY_COLOR"
    seperator_themed="${seperator_color}${seperator}"
  elif [[ "$SEGMENT_POSITION" == 'right' ]]; then
    part_splitter=" $settings_segment_splitter_right "
    seperator="$settings_segment_separator_right"
    local seperator_color
    decorate::print_fg_color 'seperator_color' "$PRIMARY_COLOR"
    seperator_themed="${seperator_color}${seperator}"
  fi

  local segment_colors
  decorate::print_colors 'segment_colors' "$SECONDARY_COLOR" "$PRIMARY_COLOR"


  local part_splitter_length="${#part_splitter}"

  if [[ "$SEGMENT_LINE_POSITION" -gt 1 ]]; then
    segment_length="${#seperator}"
    themed_segment="$seperator_themed"
  fi

  themed_segment="${themed_segment}${segment_colors}"

  if [[ "${#@}" -gt 1 ]]; then
    local splitter_color_on
    decorate::print_fg_color 'splitter_color_on' "$SPLITTER_COLOR"
    local local splitter_color_off
    decorate::print_fg_color 'splitter_color_off' "$SECONDARY_COLOR"
    part_splitter_themed="${splitter_color_on}${part_splitter}${splitter_color_off}"
  fi

  local themed_parts

  for part in "${@}"; do
    part_length="${#part}"

    if [[ -n "$themed_parts" ]]; then
      themed_parts="${themed_parts}${part_splitter_themed}${part}"
      segment_length=$(( segment_length + part_length + part_splitter_length ))
    else
      segment_length="$(( segment_length + part_length))"
      themed_parts="${part}"
    fi
  done

  themed_segment="${themed_segment} ${themed_parts} "
  segment_length=$(( segment_length + 2 ))

  local prepare_color=
  decorate::print_colors 'prepare_color' "$PRIMARY_COLOR" "$PRIMARY_COLOR"
  themed_segment="${themed_segment_colors}${themed_segment}${prepare_color}"
  printf '%s;;%s' "$segment_length" "$themed_segment"
}
