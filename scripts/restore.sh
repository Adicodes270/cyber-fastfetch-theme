#!/usr/bin/env bash
# Restore the fastfetch config that existed before the theme was applied.

set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch"
backup_dir="$config_dir/backup"

if [[ ! -f "$backup_dir/config.jsonc.bak" ]]; then
  echo "no backup found" >&2
  exit 3
fi

install -m 0644 -- "$backup_dir/config.jsonc.bak" "$config_dir/config.jsonc"

if [[ -f "$backup_dir/cyber_logo.txt.bak" ]]; then
  install -m 0644 -- "$backup_dir/cyber_logo.txt.bak" "$config_dir/cyber_logo.txt"
else
  rm -f -- "$config_dir/cyber_logo.txt"
fi
