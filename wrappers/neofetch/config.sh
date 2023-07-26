# See this wiki page for more info:
# https://github.com/dylanaraps/neofetch/wiki/Customizing-Info

if [ -x "$(command -v nvidia-smi)" ]
then
    MY_VIDEO="$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader), driver $(nvidia-smi --query-gpu=driver_version --format=csv,noheader) [$(nvidia-smi --query-gpu='temperature.gpu' --format=csv | tail -n 1)°C]"
else
    MY_VIDEO="$(lspci -mm |
                       awk -F '\"|\" \"|\\(' \
                              '/"Display|"3D|"VGA/ {
                                  a[$0] = $1 " " $3 " " ($(NF-1) ~ /^$|^Device [[:xdigit:]]+$/ ? $4 : $(NF-1))
                              }
                              END { for (i in a) {
                                  if (!seen[a[i]]++) {
                                      sub("^[^ ]+ ", "", a[i]);
                                      print a[i]
                                  }
                              }}')"
fi

for i in {31..36}; do
    panes+="[${i}m "
done

print_info() {
    prin
    prin " " "github.com/viperML/dotfiles"
    info " " kernel
    info " " cpu
    prin "󰊚 " "${MY_VIDEO}"
    info "󰍛 " memory
    info "󰹑 " resolution


    info " " wm
    # info "$ " shell
    info " " term
    # info " " term_font
    prin " " "--> =<< |> <!-- !="



    prin " " "$panes"
}


# Info Separator
# Replace the default separator with the specified string.
#
# Default:  ':'
# Flag:     --separator
#
# Example:
# separator="->":   'Shell-> bash'
# separator=" =":   'WM = dwm'
separator=" "


# Shell


# Show the path to $SHELL
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --shell_path
#
# Example:
# on:  '/bin/bash'
# off: 'bash'
shell_path="off"

# Show $SHELL version
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --shell_version
#
# Example:
# on:  'bash 4.4.5'
# off: 'bash'
shell_version="off"


# CPU


# CPU speed type
#
# Default: 'bios_limit'
# Values: 'scaling_cur_freq', 'scaling_min_freq', 'scaling_max_freq', 'bios_limit'.
# Flag:    --speed_type
# Supports: Linux with 'cpufreq'
# NOTE: Any file in '/sys/devices/system/cpu/cpu0/cpufreq' can be used as a value.
speed_type="scaling_max_freq"

# CPU speed shorthand
#
# Default: 'off'
# Values: 'on', 'off'.
# Flag:    --speed_shorthand
# NOTE: This flag is not supported in systems with CPU speed less than 1 GHz
#
# Example:
# on:    'i7-6500U (4) @ 3.1GHz'
# off:   'i7-6500U (4) @ 3.100GHz'
speed_shorthand="on"

# Enable/Disable CPU brand in output.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --cpu_brand
#
# Example:
# on:   'Intel i7-6500U'
# off:  'i7-6500U (4)'
cpu_brand="on"

# CPU Speed
# Hide/Show CPU speed.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --cpu_speed
#
# Example:
# on:  'Intel i7-6500U (4) @ 3.1GHz'
# off: 'Intel i7-6500U (4)'
cpu_speed="on"

# CPU Cores
# Display CPU cores in output
#
# Default: 'logical'
# Values:  'logical', 'physical', 'off'
# Flag:    --cpu_cores
# Support: 'physical' doesn't work on BSD.
#
# Example:
# logical:  'Intel i7-6500U (4) @ 3.1GHz' (All virtual cores)
# physical: 'Intel i7-6500U (2) @ 3.1GHz' (All physical cores)
# off:      'Intel i7-6500U @ 3.1GHz'
cpu_cores="logical"

# CPU Temperature
# Hide/Show CPU temperature.
# Note the temperature is added to the regular CPU function.
#
# Default: 'off'
# Values:  'C', 'F', 'off'
# Flag:    --cpu_temp
# Supports: Linux, BSD
# NOTE: For FreeBSD and NetBSD-based systems, you'll need to enable
#       coretemp kernel module. This only supports newer Intel processors.
#
# Example:
# C:   'Intel i7-6500U (4) @ 3.1GHz [27.2°C]'
# F:   'Intel i7-6500U (4) @ 3.1GHz [82.0°F]'
# off: 'Intel i7-6500U (4) @ 3.1GHz'
cpu_temp="C"

# Shell


# Show the path to $SHELL
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --shell_path
#
# Example:
# on:  '/bin/bash'
# off: 'bash'
shell_path="on"

# Show $SHELL version
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --shell_version
#
# Example:
# on:  'bash 4.4.5'
# off: 'bash'
shell_version="on"


# Memory


# Show memory pecentage in output.
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --memory_percent
#
# Example:
# on:   '1801MiB / 7881MiB (22%)'
# off:  '1801MiB / 7881MiB'
memory_percent="on"

# Change memory output unit.
#
# Default: 'mib'
# Values:  'kib', 'mib', 'gib'
# Flag:    --memory_unit
#
# Example:
# kib  '1020928KiB / 7117824KiB'
# mib  '1042MiB / 6951MiB'
# gib: ' 0.98GiB / 6.79GiB'
memory_unit="mib"

# Resolution

# Display refresh rate next to each monitor
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --refresh_rate
# Supports: Doesn't work on Windows.
#
# Example:
# on:  '1920x1080 @ 60Hz'
# off: '1920x1080'
refresh_rate="on"



# Text Colors


# Text Colors
#
# Default:  'distro'
# Values:   'distro', 'num' 'num' 'num' 'num' 'num' 'num'
# Flag:     --colors
#
# Each number represents a different part of the text in
# this order: 'title', '@', 'underline', 'subtitle', 'colon', 'info'
#
# Example:
# colors=(distro)      - Text is colored based on Distro colors.
# colors=(4 6 1 8 8 6) - Text is colored in the order above.
colors=(0 0 0 6 0 7)


# Text Options


# Toggle bold text
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --bold
bold="on"

# Enable/Disable Underline
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --underline
underline_enabled="on"

# Underline character
#
# Default:  '-'
# Values:   'string'
# Flag:     --underline_char
underline_char="-"





# Color Blocks


# Color block range
# The range of colors to print.
#
# Default:  '0', '15'
# Values:   'num'
# Flag:     --block_range
#
# Example:
#
# Display colors 0-7 in the blocks.  (8 colors)
# neofetch --block_range 0 7
#
# Display colors 0-15 in the blocks. (16 colors)
# neofetch --block_range 0 15
block_range=(0 15)

# Toggle color blocks
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --color_blocks
color_blocks="on"

# Color block width in spaces
#
# Default:  '3'
# Values:   'num'
# Flag:     --block_width
block_width=5

# Color block height in lines
#
# Default:  '1'
# Values:   'num'
# Flag:     --block_height
block_height=1

# Color Alignment
#
# Default: 'auto'
# Values: 'auto', 'num'
# Flag: --col_offset
#
# Number specifies how far from the left side of the terminal (in spaces) to
# begin printing the columns, in case you want to e.g. center them under your
# text.
# Example:
# col_offset="auto" - Default behavior of neofetch
# col_offset=7      - Leave 7 spaces then print the colors
col_offset="auto"


# Backend Settings


# Image backend.
#
# Default:  'ascii'
# Values:   'ascii', 'caca', 'chafa', 'jp2a', 'iterm2', 'off',
#           'pot', 'termpix', 'pixterm', 'tycat', 'w3m', 'kitty'
# Flag:     --backend
image_backend="ascii"

# Image Source
#
# Which image or ascii file to display.
#
# Default:  'auto'
# Values:   'auto', 'ascii', 'wallpaper', '/path/to/img', '/path/to/ascii', '/path/to/dir/'
#           'command output (neofetch --ascii "$(fortune | cowsay -W 30)")'
# Flag:     --source
#
# NOTE: 'auto' will pick the best image source for whatever image backend is used.
#       In ascii mode, distro ascii art will be used and in an image mode, your
#       wallpaper will be used.
source /etc/os-release
image_source="$FLAKE/misc/ascii/$NAME.txt"


# Ascii Options


# Ascii distro
# Which distro's ascii art to display.
#
# Default: 'auto'
# Values:  'auto', 'distro_name'
# Flag:    --ascii_distro
# NOTE: AIX, Alpine, Anarchy, Android, Antergos, antiX, "AOSC OS",
#       "AOSC OS/Retro", Apricity, ArcoLinux, ArchBox, ARCHlabs,
#       ArchStrike, XFerience, ArchMerge, Arch, Artix, Arya, Bedrock,
#       Bitrig, BlackArch, BLAG, BlankOn, BlueLight, bonsai, BSD,
#       BunsenLabs, Calculate, Carbs, CentOS, Chakra, ChaletOS,
#       Chapeau, Chrom*, Cleanjaro, ClearOS, Clear_Linux, Clover,
#       Condres, Container_Linux, CRUX, Cucumber, Debian, Deepin,
#       DesaOS, Devuan, DracOS, DarkOs, DragonFly, Drauger, Elementary,
#       EndeavourOS, Endless, EuroLinux, Exherbo, Fedora, Feren, FreeBSD,
#       FreeMiNT, Frugalware, Funtoo, GalliumOS, Garuda, Gentoo, Pentoo,
#       gNewSense, GNOME, GNU, GoboLinux, Grombyang, Guix, Haiku, Huayra,
#       Hyperbola, janus, Kali, KaOS, KDE_neon, Kibojoe, Kogaion,
#       Korora, KSLinux, Kubuntu, LEDE, LFS, Linux_Lite,
#       LMDE, Lubuntu, Lunar, macos, Mageia, MagpieOS, Mandriva,
#       Manjaro, Maui, Mer, Minix, LinuxMint, MX_Linux, Namib,
#       Neptune, NetBSD, Netrunner, Nitrux, NixOS, Nurunner,
#       NuTyX, OBRevenge, OpenBSD, openEuler, OpenIndiana, openmamba,
#       OpenMandriva, OpenStage, OpenWrt, osmc, Oracle, OS Elbrus, PacBSD,
#       Parabola, Pardus, Parrot, Parsix, TrueOS, PCLinuxOS, Peppermint,
#       popos, Porteus, PostMarketOS, Proxmox, Puppy, PureOS, Qubes, Radix,
#       Raspbian, Reborn_OS, Redstar, Redcore, Redhat, Refracted_Devuan,
#       Regata, Rosa, sabotage, Sabayon, Sailfish, SalentOS, Scientific,
#       Septor, SereneLinux, SharkLinux, Siduction, Slackware, SliTaz,
#       SmartOS, Solus, Source_Mage, Sparky, Star, SteamOS, SunOS,
#       openSUSE_Leap, openSUSE_Tumbleweed, openSUSE, SwagArch, Tails,
#       Trisquel, Ubuntu-Budgie, Ubuntu-GNOME, Ubuntu-MATE, Ubuntu-Studio,
#       Ubuntu, Venom, Void, Obarun, windows10, Windows7, Xubuntu, Zorin,
#       and IRIX have ascii logos
# NOTE: Arch, Ubuntu, Redhat, and Dragonfly have 'old' logo variants.
#       Use '{distro name}_old' to use the old logos.
# NOTE: Ubuntu has flavor variants.
#       Change this to Lubuntu, Kubuntu, Xubuntu, Ubuntu-GNOME,
#       Ubuntu-Studio, Ubuntu-Mate  or Ubuntu-Budgie to use the flavors.
# NOTE: Arcolinux, Dragonfly, Fedora, Alpine, Arch, Ubuntu,
#       CRUX, Debian, Gentoo, FreeBSD, Mac, NixOS, OpenBSD, android,
#       Antrix, CentOS, Cleanjaro, ElementaryOS, GUIX, Hyperbola,
#       Manjaro, MXLinux, NetBSD, Parabola, POP_OS, PureOS,
#       Slackware, SunOS, LinuxLite, OpenSUSE, Raspbian,
#       postmarketOS, and Void have a smaller logo variant.
#       Use '{distro name}_small' to use the small variants.
ascii_distro="auto"

# Ascii Colors
#
# Default:  'distro'
# Values:   'distro', 'num' 'num' 'num' 'num' 'num' 'num'
# Flag:     --ascii_colors
#
# Example:
# ascii_colors=(distro)      - Ascii is colored based on Distro colors.
# ascii_colors=(4 6 1 8 8 6) - Ascii is colored using these colors.
ascii_colors=(distro)

# Bold ascii logo
# Whether or not to bold the ascii logo.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --ascii_bold
ascii_bold="on"


# Image Options


# Image loop
# Setting this to on will make neofetch redraw the image constantly until
# Ctrl+C is pressed. This fixes display issues in some terminal emulators.
#
# Default:  'off'
# Values:   'on', 'off'
# Flag:     --loop
image_loop="off"

# Thumbnail directory
#
# Default: '~/.cache/thumbnails/neofetch'
# Values:  'dir'
thumbnail_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/thumbnails/neofetch"

# Crop mode
#
# Default:  'normal'
# Values:   'normal', 'fit', 'fill'
# Flag:     --crop_mode
#
# See this wiki page to learn about the fit and fill options.
# https://github.com/dylanaraps/neofetch/wiki/What-is-Waifu-Crop%3F
crop_mode="fit"

# Crop offset
# Note: Only affects 'normal' crop mode.
#
# Default:  'center'
# Values:   'northwest', 'north', 'northeast', 'west', 'center'
#           'east', 'southwest', 'south', 'southeast'
# Flag:     --crop_offset
crop_offset="center"

# Image size
# The image is half the terminal width by default.
#
# Default: 'auto'
# Values:  'auto', '00px', '00%', 'none'
# Flags:   --image_size
#          --size
image_size="250px"

# Gap between image and text
#
# Default: '3'
# Values:  'num', '-num'
# Flag:    --gap
gap=4

# Image offsets
# Only works with the w3m backend.
#
# Default: '0'
# Values:  'px'
# Flags:   --xoffset
#          --yoffset
yoffset=0
xoffset=0

# Image background color
# Only works with the w3m backend.
#
# Default: ''
# Values:  'color', 'blue'
# Flag:    --bg_color
background_color=
