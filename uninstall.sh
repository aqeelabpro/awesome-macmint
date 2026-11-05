#!/usr/bin/env bash
set -euo pipefail

data_home=${XDG_DATA_HOME:-"$HOME/.local/share"}
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
state_dir="$data_home/awesome-macmint/backup"
targets=("$HOME/.themes/MacMint" "$HOME/.icons/MacMint" "$config_home/touchegg/touchegg.conf" "$config_home/systemd/user/touchegg-client.service")

if [[ ! -f "$state_dir/.installed-0" && ! -f "$state_dir/.installed-1" && ! -f "$state_dir/.installed-2" && ! -f "$state_dir/.installed-3" ]]; then
  printf 'No MacMint installation backup was found; nothing was changed.\n'
  exit 0
fi

if [[ -f "$state_dir/.installed-3" ]] && command -v systemctl >/dev/null && systemctl --user show-environment >/dev/null 2>&1; then
  systemctl --user disable --now touchegg-client.service 2>/dev/null || true
fi

for i in "${!targets[@]}"; do
  [[ -f "$state_dir/.installed-$i" ]] || continue
  target=${targets[$i]}
  rm -rf -- "$target"
  previous="$state_dir/original/$i/previous"
  if [[ -e "$previous" || -L "$previous" ]]; then
    mkdir -p "$(dirname -- "$target")"
    cp -a -- "$previous" "$target"
  fi
done

if [[ -f "$state_dir/.installed-appearance" && -f "$state_dir/appearance.tsv" ]]; then
  if ! command -v gsettings >/dev/null || ! gsettings get org.cinnamon.desktop.interface gtk-theme >/dev/null 2>&1; then
    printf 'Cannot restore saved appearance outside a graphical login session. Run uninstall.sh again from Cinnamon.\n' >&2
    exit 1
  fi
  while IFS=$'\t' read -r schema key value; do
    [[ -n "$schema" && -n "$key" && -n "$value" ]] || continue
    gsettings set "$schema" "$key" "$value"
  done < "$state_dir/appearance.tsv"
fi

if [[ -f "$state_dir/.installed-3" ]] && command -v systemctl >/dev/null && systemctl --user show-environment >/dev/null 2>&1; then
  systemctl --user daemon-reload
fi
rm -rf -- "$state_dir"
printf 'MacMint files and prior user settings have been restored.\n'
