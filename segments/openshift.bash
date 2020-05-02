#! /usr/bin/env bash
segment_generate_openshift() {
  segment_direction=$3
  if grep -q token "${HOME}/.kube/config" &>/dev/null; then
    config="$(sed -n 's|current-context: \(.*\)/\(.*\)/\(.*\)$|\1;\2;\3|p' "${HOME}/.kube/config")"
    project="$(cut -d ';' -f 1 <<<"$config")"
    cluster="$(cut -d ';' -f 2 <<<"$config" | sed 's/:443//')"
    user="$(cut -d ';' -f 3 <<<"$config")"

    if [[ "${user,,}" == "${settings_openshift_default_user,,}" ]]; then
      if [[ "$settings_openshift_hide_cluster" -eq 1 ]]; then
        segment="${project}"
      else
        segment="${cluster}:${project}"
      fi
    else
      segment="${user}@${cluster}:${project}"
    fi

    pretty_print_segment "$settings_openshift_color_primary" "$settings_openshift_color_secondary" " ${segment} " "$segment_direction"
  fi
}
