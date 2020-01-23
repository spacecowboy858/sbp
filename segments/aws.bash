#! /usr/bin/env bash

# shellcheck source=functions/decorate.bash
source "${sbp_path}/functions/decorate.bash"

segment_direction=$3
if [[ -n "$AWS_DEFAULT_PROFILE" ]]; then
  pretty_print_segment "$settings_aws_color_primary" "$settings_aws_color_secondary" " ${AWS_DEFAULT_PROFILE} " "$segment_direction"
fi
