#! /usr/bin/env bash

# shellcheck source=functions/decorate.bash
source "${sbp_path}/functions/decorate.bash"

segment_direction=$3

timestamp_value=$(date +"$settings_timestamp_format")
pretty_print_segment "$settings_timestamp_color_primary" "$settings_timestamp_color_secondary" " ${timestamp_value} " "$segment_direction"


