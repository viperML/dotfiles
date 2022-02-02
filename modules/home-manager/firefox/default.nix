{ config, pkgs, inputs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta-bin;
    # https://nur.nix-community.org/repos/rycee/
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      betterttv
      bitwarden
      darkreader
      return-youtube-dislikes
      sponsorblock
      violentmonkey
      wayback-machine
      ublock-origin
      unpaywall
      bypass-paywalls-clean
      floccus
    ];
    profiles.main = {
      id = 0;
      userChrome = ''
        ${builtins.readFile ./userChrome.css}

        ${builtins.readFile "${inputs.firefox-csshacks.outPath}/chrome/urlbar_centered_text.css"}
      '';
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };
}
