lib:
with lib; let
  example = {
    "file" = "~/.config/kglobalshortcutsrc";
    "group" = "kwin";
    "values" = {
      "bismuth_next_layout" = "Meta+L,none,Bismuth: Switch to the Next Layout";
      "bismuth_toggle_window_floating" = "Meta+Z,none,Bismuth: Toggle Active Window Floating";
    };
  };

  writeKConfig = input: let
    result = concatStringsSep "\n" (attrValues (mapAttrs (keyName: keyValue: ''kwriteconfig --file ${input.file} --group ${input.group} --key ${keyName} "${keyValue}"'') input.values));
  in
    ''
      test -f ${input.file}
    ''
    + result;
in {
  inherit writeKConfig example;
}
