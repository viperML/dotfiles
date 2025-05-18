{ yazi }:
yazi.override {
  settings.keymap = builtins.readFile ./keymap.toml |> builtins.fromTOML;
}
