
<!-- Create a centered title -->
<h1 style="text-align: center">viperML/dotfiles</h1>

# About
These are my personal configuration files for my Linux and Windows machines. Feel free to grab anything that you find interesting.


<div align="center">
  <div style="display: flex; align-items: flex-start;">
    <img alt="Desktop screenshot" src=".img/20211010.png" width="100%"/>
  </div>
</div>

# Installation

<div align="center">
  <div style="display: flex; align-items: flex-start;">
    <img alt="Nix logo" src="https://nixos.org/logo/nixos-logo-only-hires.png" width="20%">
  </div>
</div>

Most of the configuration files are managed with a [Nix Flake](https://nixos.wiki/wiki/Flakes) and [Home Manager](https://github.com/nix-community/home-manager), which is self-contained, distro-agnostic and doesn't require any additional software apart from the [nix package manager](https://nixos.org/download.html).

```
git clone https://github.com/viperML/dotfiles && cd dotfiles
nix-shell
nix build .#homeManagerConfigurations.ayats.activationPackage
./result/activate
```

That is how I install it myself, but I don't recommend it for you. Instead, pick any specific files or snippets of code.


# Resources
- [Visual Studio Code](https://code.visualstudio.com/) - IDE/Text editor of choice. Installed extensions are located in [extensions](Code/extensions)
- [Neovim](https://neovim.io/) - Vim fork which aims to improve the extensibility and maintainability.
- [fish](https://fishshell.com/) - Interactive shell, providing automatic completion and syntax highlight out of the box.
- [starship](https://starship.rs/) - Shell prompt with powerful customization.
- [Konsole](https://konsole.kde.org/) - Modern terminal emulator
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/) - Monospaced font with ligatures support.
- [multiload-ng](https://udda.github.io/multiload-ng/) - System tray load monitors
- [WhiteSur](https://github.com/vinceliuice/WhiteSur-kde) - GTK 2.0 / GTK 3.0 / QT Theme
- [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) - Icon theme
- [Lightly](https://github.com/Luwx/Lightly) - Titlebar decorations
- [Latte Dock](https://github.com/KDE/latte-dock) - Panel/dock replacement for KDE
- [bat](https://github.com/sharkdp/bat) - Cat clone with syntax highlighting

- Deprecated configurations:
- [Awesome WM](https://awesomewm.org/doc/api/index.html) - Dynamic window manager configured in Lua, whith a good balance between minimalism and extensibility
- [Rofi](https://github.com/davatorium/rofi) - Application launcher
- [viperML/st](https://github.com/viperML/st) - Terminal emulator
- [jonaburg/picom](https://github.com/jonaburg/picom) - Compositor, providing transparency, shadows and rounded corners for Awesome. Jonaburg's fork includes animations
- [oh-my-posh](https://ohmyposh.dev) - Shell prompt with powerful customization. Deprecated use in favor of starship.

> Last update of this README: November 2021
