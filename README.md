# Awesome MacMint

MacMint is a macOS-inspired theme and desktop setup for Linux Mint Cinnamon. It brings together GTK 2/3/4 and libadwaita styling, Cinnamon and window-manager decorations, a matching icon theme, and optional Touchégg trackpad gestures. It is an independent project and does not use WhiteSur source code or assets.

## Features

- GTK, Cinnamon, Metacity, XFWM4, Openbox, and libadwaita theme assets
- Matching window control and sidebar icons
- Optional Touchégg gestures for workspace, window, app switching, and browser controls
- User-level install and uninstall scripts with backups of pre-existing MacMint files

## Requirements

- Linux Mint Cinnamon (GTK theme files can also be used by other GTK desktops, with desktop-specific behavior varying)
- Bash and standard GNU utilities
- Touchégg 2.x for gestures; install it through your distribution before installing MacMint
- A systemd user session to enable the provided gesture service automatically

## Install

Clone the repository and run the installer as your regular user. It does not use `sudo`.

```sh
git clone https://github.com/aqeelabpro/awesome-macmint.git
cd awesome-macmint
./install.sh
```

To install just the theme and icons:

```sh
./install.sh --no-gestures
```

The installer selects MacMint automatically and saves the existing theme, icon, cursor, and window-button settings for uninstall. Run it from a graphical Cinnamon session for the automatic selection and restore to work. If it was run outside that session, rerun it after logging in. If the gesture service could not start during installation, start it from a graphical login session with:

```sh
systemctl --user enable --now touchegg-client.service
```

## Gestures

The supplied Touchégg profile is based on the project maintainer's Linux Mint setup. Key combinations depend on Cinnamon's keyboard shortcuts, and application matching depends on Touchégg's reported application name.

| Gesture | Action |
| --- | --- |
| Three-finger swipe up/down | Send Ctrl+Alt+Up/Down (Cinnamon overview/workspace shortcut) |
| Three-finger swipe left/right | Switch apps with Alt+Shift+Tab / Alt+Tab |
| Three-finger pinch in | Close the active window |
| Four-finger swipe left/right | Change workspace |
| Four-finger swipe up/down | Send Ctrl+Alt+Up/Down |
| Four-finger pinch out | Show desktop |
| Four-finger pinch in | Send Super+A (app drawer shortcut) |
| Two-finger tap / three-finger tap | Right-click / middle-click |
| Chrome/Chromium two-finger pinch | Zoom in/out |
| Chrome/Chromium two-finger swipe left/right | Browser back/forward |

Edit `gestures/touchegg.conf` to customize the mappings. Reinstall or copy it to `~/.config/touchegg/touchegg.conf`, then restart the user service. Touchégg availability and gesture recognition depend on the device, compositor, and session type.

## Uninstall

Run:

```sh
./uninstall.sh
```

The installer backs up any existing MacMint theme, icon theme, Touchégg config, service, and current appearance settings in `${XDG_DATA_HOME:-~/.local/share}/awesome-macmint/backup`. Uninstall removes the installed copies and restores those previous files and settings automatically. The backup is deleted after a successful restore.

## Contributing

Bug reports and contributions are welcome. Please include your Linux Mint/Cinnamon version, session type, Touchégg version, device model, and relevant logs for gesture issues. Keep changes original, preserve third-party notices, and include licensing information for any new assets.

## License and attribution

MacMint's theme is derived from Linux Mint's Mint-Y theme. Inherited Mint-Y files and this combined theme are distributed under GPL-3.0-or-later; see [`LICENSE`](LICENSE) and retain existing copyright notices. MacMint-specific additions are provided under the same license. Touchégg is a separate project and is not included here.
