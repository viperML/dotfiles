# viperML/dotfiles

![](_img/2021_04_%204_0250.png)

Config files for my Windows and Linux machines. Feel free to grab the parts that you find interesting.

- [anishathalye/dotbot](https://github.com/anishathalye/dotbot)
sets up symlinks by calling `pwsh dotbot.ps1 -c install-arch.yml`. Only requires python 3 and powershell.



## Common dependencies
- [Visual Studio Code](https://code.visualstudio.com) Installed extensions should be in [extensions](Code/extensions) if I remember to update it.
- [oh-my-posh](https://ohmyposh.dev) Theme engine, used both for my Linux and Windows shell.
- Fonts:
  - [Fira Code](https://github.com/tonsky/FiraCode) - Monospaced
  - Roboto - Sans
  - [JoyPixels](https://www.joypixels.com) - Emoji (Installation: https://bugs.archlinux.org/task/66080)
  - [Font Awesome](https://fontawesome.com) - Additional icons
  - Liberation Sans & Segoe UI - Linux & Windows font fallbacks


## Arch Linux dependencies
- [i3-gaps](https://github.com/Airblader/i3) - Tiling window manager
  - [i3wsr](https://github.com/roosta/i3wsr) - Change the name of a workspace based on its contents
  - [xfce4-i3-workspaces-plugin](https://github.com/denesb/xfce4-i3-workspaces-plugin) - Show workspaces in xfce4-panel
- [xfce4](https://xfce.org) - Window Manager and Desktop are disabled, provides session, settings daemon, power daemon, notifications and volume control.
  - [multiload-ng](https://udda.github.io/multiload-ng/) - System monitors
- [ibhagwan/picom](https://github.com/ibhagwan/picom/) - Compositor, providing transparency, shadows, rounded corners and borders.
- [fish](https://fishshell.com) - Shell
- [kitty](https://sw.kovidgoyal.net/kitty/) - Terminal emulator
- GTK/Icon theme in the neofetch screenshot above

If there is anything missing, either I forgot to add it, I don't use it anymore or it is not interesting to merge into your config files.


## To-Do:
- [x] oh-my-posh prompt
- [x] VSCode theme
- [x] terminal colors
- [ ] xfce-panels
- [ ] Theme & icons

## Atribution

- [qualia.conf](kitty/qualia.conf) terminal color palette by [u/starlig-ht](https://www.reddit.com/r/unixporn/comments/hjzw5f/oc_qualitative_color_palette_for_ansi_terminal/)
- Some parts in [gtk.css](gtk-3.0/gtk.css) from [Mehedirm/dotfiles_v2](https://github.com/Mehedirm/dotfiles_v2)