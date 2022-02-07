{ config, pkgs, ... }:
let
  # BetterDiscord plugin definitions
  imageEmojis = pkgs.fetchurl {
    url = "https://github.com/MateusAquino/ImageEmojis/releases/download/v0.2.3/ImageEmojis.plugin.js";
    sha256 = "1ialbrh94k2hak16zi0spcn1gff11f7j5qvgl5bnwq77xqiyp3fn";
  };
  BetterFriendList = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/3cdb1935d43b76001c411ce8b049e1fe685834f7/Plugins/BetterFriendList/BetterFriendList.plugin.js";
    sha256 = "0814p6fwm6y1f51nsv2lcw6fxs6nv3y43i7rn2sf8pzcx8q7q5k4";
  };
  BDLibrary = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/bf424995295bc9037af7421ddf826074fc29ff0e/Library/0BDFDB.plugin.js";
    sha256 = "1c8zam5jak9214vnnsrj5jdaywh99na1aifkbx67x19s4hk5lyk1";
  };
  bdcompat-withPlugins = pkgs.bdcompat.override {
    plugins = [
      imageEmojis
      BetterFriendList
BDLibrary
    ];
  };

  # Powercord plugin definitions

  # Everything together
  discord-plugged-withPlugins = pkgs.discord-plugged.override {
    plugins = [
      bdcompat-withPlugins
    ];
  };
in
{
  # home.packages = [ discord-plugged-withPlugins ];
}
