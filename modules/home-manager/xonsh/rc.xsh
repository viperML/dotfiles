from xonsh.tools import register_custom_style

# General
$COMMANDS_CACHE_SAVE_INTERMEDIATE = True

# Interactive Prompt
$AUTO_SUGGEST_IN_COMPLETIONS = True

# Tab-completion behavior
$COMPLETIONS_MENU_ROWS = 4
# $COMPLETION_IN_THREAD = True
$COMPLETION_MODE = "menu-complete"

# Colors
mystyle = {
    "PTK.CompletionMenu.Completion": "noinherit"
}
register_custom_style("mystyle", mystyle)
$XONSH_COLOR_STYLE="mystyle"

$fzf_history_binding = "c-r"  # Ctrl+R
# $fzf_ssh_binding = "c-s"      # Ctrl+S
$fzf_file_binding = "c-f"      # Ctrl+T
# $fzf_dir_binding = "c-g"      # Ctrl+G

aliases['ls'] = "exa --icons"
aliases['la'] = "exa --icons --all"
aliases['ll'] = "exa --icons --long --header --group"
aliases['lla'] = "exa --icons --all --long --header --group"
aliases['lal'] = "exa --icons --all --long --header --group"
aliases['lt'] = "exa --sort modified -1"

abbrevs['p'] = "python"
abbrevs['n'] = "nvim"
abbrevs['x'] = "xdg-open"
abbrevs['ss'] = "sudo systemctl"
abbrevs['us'] = "systemctl --user"
abbrevs['se'] = "sudo -E systemctl edit"
abbrevs['vl'] = "$FLAKE/modules/home-manager/vscode/extensions/updater.sh"
abbrevs['wat'] = "wezterm imgcat"
abbrevs['gd'] = "git diff"
# abbrevs['gdd'] = "git diff | grep -v '^diff\|^index' | bat"
abbrevs['ga'] = "git add"
abbrevs['gaa'] = "git add --all ."
abbrevs['gbd'] = "git branch -D"
abbrevs['gs'] = "git status"
abbrevs['gca'] = "git commit -a -m"
abbrevs['gm'] = "git merge"
abbrevs['gpt'] = "git push --tags"
abbrevs['gp'] = "git push"
abbrevs['grh'] = "git reset --hard"
abbrevs['gb'] = "git branch"
abbrevs['gcob'] = "git checkout -b"
abbrevs['gco'] = "git checkout"
abbrevs['gba'] = "git branch -a"
abbrevs['gcp'] = "git cherry-pick"
# abbrevs['gl'] = "git log --pretty=format:\"%Cgreen%h%Creset - %Cblue%an%Creset @ %ar : %s\""
# abbrevs['gl2'] = "git log --pretty='format:%Cgreen%h%Creset %an - %s' --graph"
abbrevs['glv'] = "git log --stat"
abbrevs['gpom'] = "git pull origin master"
abbrevs['gcd'] = 'cd "`git rev-parse --show-toplevel`"'
abbrevs['gcf'] = "git clean -fd"
abbrevs['gcod'] = "git checkout -- ."
abbrevs['gpum'] = "git pull upstream master"
abbrevs['gpod'] = "git push origin --delete"
abbrevs['gsu'] = "git status -uno"
abbrevs['gcm'] = "git commit -m"
abbrevs['gcv'] = "git commit --verbose"
abbrevs['gc'] = "git commit --verbose"
abbrevs['gds'] = "git diff | sublime"
abbrevs['grm'] = "git reset HEAD"
abbrevs['gacm'] = "git add . --all; git commit --verbose"
# abbrevs['gtd'] = "git log --tags --simplify-by-decoration --pretty=\"format:%ai %d\""
abbrevs['grs'] = "git shortlog -s -n --all --no-merges"
abbrevs['gss'] = "git status --short"
abbrevs['gr'] = "cd (git-root)"
