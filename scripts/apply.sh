#!/usr/bin/env bash
# Install the Cyber Fastfetch preset into the user's fastfetch config.
#
# The first real config the user has is copied to backup/ exactly once, so
# pressing Apply twice never overwrites the original backup with the themed
# config.

set -euo pipefail

plugin_dir="${1:-}"
if [[ -z $plugin_dir ]]; then
  echo "usage: apply.sh <plugin-dir>" >&2
  exit 2
fi

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch"
backup_dir="$config_dir/backup"

if [[ ! -f "$plugin_dir/presets/config.jsonc" || ! -f "$plugin_dir/presets/cyber_logo.txt" ]]; then
  echo "preset files are missing from the plugin folder" >&2
  exit 4
fi

mkdir -p "$config_dir" "$backup_dir"

if [[ -f "$config_dir/config.jsonc" && ! -e "$backup_dir/config.jsonc.bak" ]]; then
  cp -p -- "$config_dir/config.jsonc" "$backup_dir/config.jsonc.bak"
fi
if [[ -f "$config_dir/cyber_logo.txt" && ! -e "$backup_dir/cyber_logo.txt.bak" ]]; then
  cp -p -- "$config_dir/cyber_logo.txt" "$backup_dir/cyber_logo.txt.bak"
fi

install -m 0644 -- "$plugin_dir/presets/config.jsonc" "$config_dir/config.jsonc"
install -m 0644 -- "$plugin_dir/presets/cyber_logo.txt" "$config_dir/cyber_logo.txt"

if ! command -v fastfetch >/dev/null 2>&1; then
  echo "theme installed, but fastfetch is not on PATH" >&2
fi
