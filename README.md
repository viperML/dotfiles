# viperML/dotfiles

> Last update of this README: July 2021
# About
These are my personal configuration files for my Linux and Windows machines. Feel free to grab anything that you find interesting.

![](.img/2021_07_27.png)

# Installation
I am using a dotfiles boostrapper: [anishathalye/dotbot](https://github.com/anishathalye/dotbot) which
sets up symlinks by calling `sh dotbot.sh -c install-arch.yaml`. For windows, `powershell dotbot.ps1 -c install-win.yaml` (Windows related config files are deprecated and may be removed in the future).

I don't recommend pulling the whole repository, but instead copy snippets in particular.


# Main applications
- [Awesome WM](https://awesomewm.org/doc/api/index.html) - Dynamic window manager configured in Lua, whith a good balance between minimalism and extensibility
- [Visual Studio Code](https://code.visualstudio.com/) - IDE/Text editor of choice. Installed extensions are located in [extensions](Code/extensions)
- [Neovim](https://neovim.io/) - Terminal text editor
- [fish](https://fishshell.com/) - Interactive shell, providing automatic completion and syntax highlight out of the box.
- [oh-my-posh](https://ohmyposh.dev) - Shell prompt. It can be installed both in linux and windows machines and it is easily configurable via a JSON file
- Fonts:
  - JetBrains Mono - Monospaced font
  - Verdana - Sans serif font

- [jonaburg/picom](https://github.com/jonaburg/picom) - Compositor, providing transparency, shadows and rounded corners. Jonaburg's fork includes animations
- [viperML/st](https://github.com/viperML/st) - Terminal emulator
- [Rofi](https://github.com/davatorium/rofi) - Application launcher
- [multiload-ng](https://udda.github.io/multiload-ng/) - System tray load monitors
- [Orchis Dark](https://github.com/vinceliuice/Orchis-theme) - GTK 2.0 / GTK 3.0 / QT Theme
- [Vimix](https://github.com/vinceliuice/vimix-icon-theme) - Icon pack


> If there is anything missing, either I forgot to add it, I don't use it anymore or it is not interesting enough to show it off
