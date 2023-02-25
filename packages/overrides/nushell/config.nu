let carapace_completer = {|spans|
  carapace $spans.0 nushell $spans | from json
}

let-env config = {
  show_banner: false
  use_ansi_coloring: true
  completions: {
    external: {
      completer: $carapace_completer
    }
  }
  hooks: {
    pre_prompt: [{
      code: "
          let direnv = (direnv export json | from json)
          let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
          $direnv | load-env
      "
    }]
  }
  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [emacs vi_normal vi_insert]
      event: {
          until: [
          { send: menu name: completion_menu }
          { send: menunext }
          ]
      }
    }
  ]
}

# let-env STARSHIP_SHELL = "nu"
# let-env STARSHIP_SESSION_KEY = (random chars -l 16)
# let-env PROMPT_MULTILINE_INDICATOR = (^'starship' prompt --continuation)

let-env PROMPT_INDICATOR = "$ "

# let-env PROMPT_COMMAND = {
#   # jobs are not supported
#   let width = (term size).columns
#   ^'starship' prompt $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
# }

# # Whether we can show right prompt on the last line
# let has_rprompt_last_line_support = (version).version >= 0.71.0

# # Whether we have config items
# let has_config_items = (not ($env | get -i config | is-empty))


# if $has_rprompt_last_line_support {
#   let config = if $has_config_items {
#     $env.config | upsert render_right_prompt_on_last_line true
#   } else {
#     {render_right_prompt_on_last_line: true}
#   }
#   {config: $config}
# } else {
#   { }
# } | load-env

# let-env PROMPT_COMMAND_RIGHT = {
#   if $has_rprompt_last_line_support {
#     let width = (term size).columns
#     ^'starship' prompt --right $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
#   } else {
#     ''
#   }
# }
let-env PROMPT_COMMAND_RIGHT = ''
