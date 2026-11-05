# Awesome MacMint

An original macOS-inspired theme for Linux Mint Cinnamon. This repository keeps the GTK, Cinnamon, window-decoration, and icon-theme files together so they can be improved and installed as one project.

## Install

```sh
cp -a themes/MacMint ~/.themes/
cp -a icons/MacMint ~/.icons/
gsettings set org.cinnamon.desktop.interface gtk-theme MacMint
gsettings set org.cinnamon.theme name MacMint
gsettings set org.cinnamon.desktop.wm.preferences theme MacMint
gsettings set org.cinnamon.desktop.interface icon-theme MacMint
gsettings set org.gnome.desktop.interface cursor-theme DMZ-White
```

Log out and back in if Cinnamon does not reload every part of the theme immediately.

## License and attribution

MacMint is derived from Linux Mint's Mint-Y theme. The inherited Mint-Y files and this combined theme are distributed under GPL-3.0-or-later; the license text is in [`LICENSE`](LICENSE). Mint-Y attribution and copyright notices in source files are retained. The MacMint-specific styling and icon additions are maintained in this repository.
