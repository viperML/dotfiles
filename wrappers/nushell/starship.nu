open ([$env.FILE_PWD ".." "starship.toml"] | path join)
  | update character {|c| $c.character | update disabled true }
  | save --force ([$env.FILE_PWD "starship.toml"] | path join)
