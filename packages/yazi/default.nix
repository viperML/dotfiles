{ yazi }:
yazi.override (final: {
  settings.keymap = builtins.readFile ./keymap.toml |> builtins.fromTOML;
})
