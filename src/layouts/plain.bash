SETTINGS_SEGMENT_SEPARATOR_RIGHT=''
SETTINGS_SEGMENT_SEPARATOR_LEFT=''
SETTINGS_SEGMENT_SPLITTER_LEFT=''
SETTINGS_SEGMENT_SPLITTER_RIGHT=''
SETTINGS_SEGMENT_SEPARATOR_RIGHT=''
SETTINGS_SEGMENT_SEPARATOR_LEFT=''
SETTINGS_PROMPT_PREFIX_UPPER=''
SETTINGS_PROMPT_PREFIX_LOWER=''
SETTINGS_GIT_ICON=''
SETTINGS_GIT_INCOMING_ICON='out:'
SETTINGS_GIT_OUTGOING_ICON='in:'
SETTINGS_PATH_SPLITTER_DISABLE=1
SETTINGS_TIMESTAMP_FORMAT="%H:%M:%S"
SETTINGS_OPENSHIFT_DEFAULT_USER="$USER"
SETTINGS_RESCUETIME_REFRESH_RATE=600
SETTINGS_SEGMENT_ENABLE_BG_COLOR=0
SETTINGS_GIT_ICON=' '

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
