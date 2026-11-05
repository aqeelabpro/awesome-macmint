#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./install.sh [--no-gestures]

Install the MacMint GTK/Cinnamon theme and icon theme into the current user's
home directory. Touchégg gestures and a user service are installed by default.

Options:
  --no-gestures  Install only the theme and icons
  -h, --help     Show this help
EOF
}

with_gestures=1
for arg in "$@"; do
  case "$arg" in
    --no-gestures) with_gestures=0 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
  esac
done

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
for path in themes/MacMint icons/MacMint; do
  [[ -d "$script_dir/$path" ]] || { printf 'Missing project file: %s\n' "$path" >&2; exit 1; }
done
if (( with_gestures )); then
  command -v touchegg >/dev/null || { printf 'Touchégg is required for gestures. Install it first or use --no-gestures.\n' >&2; exit 1; }
fi

data_home=${XDG_DATA_HOME:-"$HOME/.local/share"}
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
state_dir="$data_home/awesome-macmint/backup"
targets=("$HOME/.themes/MacMint" "$HOME/.icons/MacMint")
appearance_keys=(
  "org.cinnamon.desktop.interface gtk-theme MacMint"
  "org.cinnamon.desktop.interface icon-theme MacMint"
  "org.cinnamon.desktop.interface cursor-theme DMZ-White"
  "org.cinnamon.theme name MacMint"
  "org.cinnamon.desktop.wm.preferences theme MacMint"
  "org.cinnamon.desktop.wm.preferences button-layout close,minimize,maximize:"
  "org.gnome.desktop.interface gtk-theme MacMint"
  "org.gnome.desktop.interface icon-theme MacMint"
  "org.gnome.desktop.interface cursor-theme DMZ-White"
  "org.gnome.desktop.wm.preferences theme MacMint"
  "org.gnome.desktop.wm.preferences button-layout close,minimize,maximize:"
)
if (( with_gestures )); then
  targets+=("$config_home/touchegg/touchegg.conf" "$config_home/systemd/user/touchegg-client.service")
fi

mkdir -p "$state_dir/original"
for i in "${!targets[@]}"; do
  target=${targets[$i]}
  if [[ ! -f "$state_dir/.backed-up-$i" ]]; then
    if [[ -e "$target" || -L "$target" ]]; then
      mkdir -p "$state_dir/original/$i"
      cp -a -- "$target" "$state_dir/original/$i/previous"
    fi
    : > "$state_dir/.backed-up-$i"
  fi
done

mkdir -p "$HOME/.themes" "$HOME/.icons"
rm -rf -- "${targets[0]}" "${targets[1]}"
cp -a -- "$script_dir/themes/MacMint" "${targets[0]}"
cp -a -- "$script_dir/icons/MacMint" "${targets[1]}"
: > "$state_dir/.installed-0"
: > "$state_dir/.installed-1"

if command -v gsettings >/dev/null && gsettings get org.cinnamon.desktop.interface gtk-theme >/dev/null 2>&1; then
  if [[ ! -f "$state_dir/.appearance-backed-up" ]]; then
    : > "$state_dir/appearance.tsv"
    for spec in "${appearance_keys[@]}"; do
      read -r schema key _desired <<< "$spec"
      printf '%s\t%s\t%s\n' "$schema" "$key" "$(gsettings get "$schema" "$key")" >> "$state_dir/appearance.tsv"
    done
    : > "$state_dir/.appearance-backed-up"
  fi
  : > "$state_dir/.installed-appearance"
  for spec in "${appearance_keys[@]}"; do
    read -r schema key desired <<< "$spec"
    gsettings set "$schema" "$key" "$desired"
  done
else
  printf 'Theme files installed. Apply MacMint from Cinnamon Themes after logging into the desktop.\n'
fi

if (( with_gestures )); then
  mkdir -p "$(dirname -- "${targets[2]}")" "$(dirname -- "${targets[3]}")"
  install -m 0644 "$script_dir/gestures/touchegg.conf" "${targets[2]}"
  install -m 0644 "$script_dir/systemd/touchegg-client.service" "${targets[3]}"
  : > "$state_dir/.installed-2"
  : > "$state_dir/.installed-3"
  if command -v systemctl >/dev/null && systemctl --user show-environment >/dev/null 2>&1; then
    systemctl --user daemon-reload
    systemctl --user enable --now touchegg-client.service
  else
    printf 'Theme installed. Enable gestures after logging into a graphical session with:\n  systemctl --user enable --now touchegg-client.service\n'
  fi
fi

printf 'MacMint installed for %s. Select MacMint in Cinnamon Themes to apply it.\n' "${USER:-current user}"
