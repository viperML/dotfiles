let direnv_installed = not (which direnv | is-empty)
let starship_installed = not (which starship | is-empty)

$env.config = {
  show_banner: false
  # use_ansi_coloring: false
  render_right_prompt_on_last_line: true
  # shell_integration: false
  hooks: {
    pre_prompt: {
      if not $direnv_installed {
        return
      }

      direnv export json | from json | default {} | load-env
    }
    command_not_found: {
      |cmd_name| (
        if ($nu.os-info.name == "linux" and 'CNF' in $env) {try {
          let raw_results = (nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root $"/bin/($cmd_name)")
          let parsed = ($raw_results | split row "\n" | each {|elem| ($elem | parse "{attr}.{output}" | first) })
          let names = ($parsed | each {|row|
            if ($row.output == "out") {
              $row.attr
            } else {
              $"($row.attr).($row.output)"
            }
          })
          let names_display = ($names | str join "\n")
          (
            "nix-index found the follwing matches:\n\n" + $names_display
          )
        } catch {
          null
        }}
      )
    }
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
  color_config: {
  }
  rm: {
    always_trash: true
  }
  table: {
    mode: compact
    index_mode: auto
  }
  completions: {
    quick: true
    partial: true
    case_sensitive: false
    algorithm: "fuzzy"
    external: (if ((which carapace | length) > 0) {
      {
        enable: true
        completer: { |spans| carapace $spans.0 nushell $spans | from json }
        max_results: 100
      }
    } else {
      {}
    })
  }
  history: {
    file_format: "sqlite"
  }
  filesize: {
    metric: false
  }
  highlight_resolved_externals: true
}

if $starship_installed {
  $env.STARSHIP_SHELL = "nu"
  $env.STARSHIP_SESSION_KEY = (random chars -l 16)
  $env.STARSHIP_SESSION_KEY = (random chars -l 16)
  $env.PROMPT_MULTILINE_INDICATOR = (starship prompt --continuation)
  $env.PROMPT_INDICATOR = "$ "
  $env.PROMPT_COMMAND = {|| starship prompt $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" }
  $env.PROMPT_COMMAND_RIGHT = ''
} else {}


if ($nu.os-info.name == "windows") {
  $env.DIRENV_CONFIG = ([ $env.APPDATA "direnv" "conf" ] | path join)
  $env.XDG_DATA_HOME = ([ $env.LOCALAPPDATA ] | path join)
  $env.XDG_CACHE_HOME = ([ $env.LOCALAPPDATA "cache" ] | path join)
}

# $env.SHELL = "nu"
