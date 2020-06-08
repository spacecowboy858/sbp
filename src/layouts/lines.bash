SETTINGS_SEGMENT_SEPARATOR_RIGHT='['
SETTINGS_SEGMENT_SEPARATOR_LEFT=']'
SETTINGS_SEGMENT_SPLITTER_LEFT='-'
SETTINGS_SEGMENT_SPLITTER_RIGHT='-'
SETTINGS_PROMPT_PREFIX_UPPER='┍'
SETTINGS_PROMPT_PREFIX_LOWER='└'
SETTINGS_PROMPT_READY_ICON="${SETTINGS_PROMPT_PREFIX_LOWER}${SETTINGS_PROMPT_READY_ICON}"
SETTINGS_SEGMENT_ENABLE_BG_COLOR=0
SETTINGS_PATH_SPLITTER_DISABLE=1
SETTINGS_PROMPT_READY_NEWLINE=1
SETTINGS_GIT_ICON=' '


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


  secondary_color="$primary_color"
  primary_color=""
  color="$(print_fg_color "$secondary_color")"

  if [[ -z "${segment_value// /}" || "$position" == 'line2' ]]; then
    full_output="${color}${segment_value}"
  else
    full_output="${color}${SETTINGS_SEGMENT_SEPARATOR_RIGHT}${segment_value}${SETTINGS_SEGMENT_SEPARATOR_LEFT}"
    segment_length=$(( segment_length + 2))
  fi

  printf '%s;;%s' "$segment_length" "$full_output"
}

