{ papirus-icon-theme }:

papirus-icon-theme.overrideAttrs (prev: {
  # https://github.com/PapirusDevelopmentTeam/papirus-folders/blob/83a22253fb1cf45178590d084517d013cb2e7bda/papirus-folders#L254
  # valid_colors=("black" "blue" "bluegrey" "breeze" "brown"
	# 	"carmine" "cyan" "darkcyan" "deeporange" "green" "grey"
	# 	"indigo" "magenta" "nordic" "orange" "palebrown" "paleorange"
	# 	"pink" "purple" "red" "teal" "violet" "white" "yaru" "yellow")
  preInstall = ''
    color="yaru"

    sizes=(22x22 24x24 32x32 48x48 64x64)
    prefixes=("folder-$color" "user-$color")
    themes=("ePapirus" "ePapirus-Dark" "Papirus" "Papirus-Dark" "Papirus-Light")

    for theme in "''${themes[@]}"; do
      for size in "''${sizes[@]}"; do
        for prefix in "''${prefixes[@]}"; do
          for file_path in "$theme/$size/places/$prefix"{-*,}.svg; do
            [ -f "$file_path" ] || continue  # is a file
            [ -L "$file_path" ] && continue  # is not a symlink

            file_name="''${file_path##*/}"
            echo "Patching ''${file_name}"
            symlink_path="''${file_path/-$color/}"  # remove color suffix

            ln -sf "$file_name" "$symlink_path" || {
                fatal "Fail to create '$symlink_path' symlink"
            }
          done
        done
      done
    done
  '';
})
