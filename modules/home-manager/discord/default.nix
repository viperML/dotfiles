{
  config,
  pkgs,
  ...
}:
let
  # # BetterDiscord plugin definitions
  # imageEmojis = pkgs.fetchurl {
  #   url = "https://github.com/MateusAquino/ImageEmojis/releases/download/v0.2.3/ImageEmojis.plugin.js";
  #   sha256 = "1ialbrh94k2hak16zi0spcn1gff11f7j5qvgl5bnwq77xqiyp3fn";
  # };
  # BetterFriendList = pkgs.fetchurl {
  #   url = "https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/3cdb1935d43b76001c411ce8b049e1fe685834f7/Plugins/BetterFriendList/BetterFriendList.plugin.js";
  #   sha256 = "0814p6fwm6y1f51nsv2lcw6fxs6nv3y43i7rn2sf8pzcx8q7q5k4";
  # };
  # BDLibrary = pkgs.fetchurl {
  #   url = "https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/bf424995295bc9037af7421ddf826074fc29ff0e/Library/0BDFDB.plugin.js";
  #   sha256 = "1c8zam5jak9214vnnsrj5jdaywh99na1aifkbx67x19s4hk5lyk1";
  # };
  DiscordFreeEmojis = pkgs.fetchFromGitHub {
    owner = "BetterDiscordPlugins";
    repo = "DiscordFreeEmojis";
    rev = "7430233b4ab352b5a859b6a6c12758ccda94dd6b";
    sha256 = "048vc23nv61wprkjdhag3cswy6ag3v5yp35rfi40c0qdg2f6q4w7";
  };
  ImageEmojis = pkgs.fetchFromGitHub {
    owner = "MateusAquino";
    repo = "ImageEmojis";
    rev = "ac463507577de6c03e2ea2d512fb344d1d2ed9a8";
    sha256 = "1rv7ikivrpp7cxwfpx5zd1r197mymayglnv8y0jc0pg0k216jmai";
  };
  bdcompat-withPlugins = pkgs.bdcompat.override {
    plugins = [
      # "${DiscordFreeEmojis}/DiscordFreeEmojis64px.plugin.js"
      "${ImageEmojis}/ImageEmojis.plugin.js"
    ];
  };
  # Powercord plugin definitions
  # Everything together
  discord-plugged-withPlugins = pkgs.discord-plugged.override {
    plugins = [
      bdcompat-withPlugins
    ];
  };
in {
  home.packages = [discord-plugged-withPlugins];
}
