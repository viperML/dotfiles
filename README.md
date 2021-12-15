
<!-- Create a centered title -->
<h1 style="text-align: center">🌠 viperML/dotfiles</h1>

# 🗒 About
These are my personal configuration files for my Linux and Windows machines. Feel free to grab anything that you find interesting.


<div align="center">
  <div style="display: flex; align-items: flex-start;">
    <img alt="Desktop screenshot" src=".img/20211118.png" width="100%"/>
  </div>
</div>

# ❄ Installation


Everything is managed by nix, using flakes and home manager. Generic Linux installs can be bootstraped using only the home-manager flake output, and there are also NixOS outputs.

To bootstrap generic Linux machine, under `ayats` user, I run:

```sh
export FLAKE=~/.dotfiles # currently hardcoded into this path
git clone https://github.com/viperML/dotfiles $FLAKE
cd $FLAKE
nix-shell --command "nix build"
./result/activate
```

To update to the latest version:

```sh
cd $FLAKE
git fetch
git pull
home-manager switch --flake $FLAKE
```


# 💾 Resources
- [Visual Studio Code](https://code.visualstudio.com/) - IDE/Text editor of choice. Installed extensions are located in [extensions](vscode/extensions)
- [Neovim](https://neovim.io/) - Vim fork which aims to improve the extensibility and maintainability.
- [Fish Shell](https://fishshell.com/) - Interactive shell, providing automatic completion and syntax highlight out of the box.
- [Starship](https://starship.rs/) - Shell prompt with powerful customization.
- [Konsole](https://konsole.kde.org/) - Modern terminal emulator
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/) - Monospaced font with ligatures support.
- [Multiload-ng](https://udda.github.io/multiload-ng/) - System tray load monitors
- [Latte Dock](https://github.com/KDE/latte-dock) - Panel/dock replacement for KDE
- [bat](https://github.com/sharkdp/bat) - Cat clone with syntax highlighting
- [lsd](https://github.com/Peltoche/lsd) - `ls` but with colors and icons (and more)

### ☠ Deprecated configurations:
- [Awesome WM](https://awesomewm.org/doc/api/index.html) - Dynamic window manager configured in Lua, whith a good balance between minimalism and extensibility
- [Rofi](https://github.com/davatorium/rofi) - Application launcher
- [viperML/st](https://github.com/viperML/st) - Terminal emulator
- [jonaburg/picom](https://github.com/jonaburg/picom) - Compositor, providing transparency, shadows and rounded corners for Awesome. Jonaburg's fork includes animations
- [oh-my-posh](https://ohmyposh.dev) - Shell prompt with powerful customization. Deprecated use in favor of starship.

> Last update of this README: November 2021
