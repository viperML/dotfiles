let direnv_installed = (which direnv | length) > 0
let starship_installed = (which starship | length) > 0

let-env config = {
  show_banner: false
  use_ansi_coloring: true
  render_right_prompt_on_last_line: true
  completions: {
    external: (if ((which carapace | length)  > 0) { {
      completer: { |spans| carapace $spans.0 nushell $spans | from json }
    } } else { {} })
  }
  hooks: {
    pre_prompt: (if $direnv_installed {
      [{
        code: "
            let direnv = (direnv export json | from json)
            let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
            $direnv | load-env
        "
      }]
    } else {[]})
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

if $starship_installed {
  let-env STARSHIP_SHELL = "nu"
  let-env STARSHIP_SESSION_KEY = (random chars -l 16)
  let-env STARSHIP_SESSION_KEY = (random chars -l 16)
  let-env PROMPT_MULTILINE_INDICATOR = (starship prompt --continuation)

  let-env PROMPT_INDICATOR = '$ '
  let-env PROMPT_COMMAND = {|| starship prompt $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" }
} else {}

let-env PROMPT_COMMAND_RIGHT = ''

if (not ($env | select windir | is-empty)) {
  let-env DIRENV_CONFIG = ([ $env.APPDATA "direnv" "conf" ] | path join)
  let-env XDG_DATA_HOME = ([ $env.LOCALAPPDATA ] | path join)
  let-env XDG_CACHE_HOME = ([ $env.LOCALAPPDATA "cache" ] | path join)
}

