{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Fernando Ayats";
    userEmail = "ayatsfer@gmail.com";

    extraConfig = {
      init.defaultBranch = "master";
      # pull.ff = "only";
      # pull.rebase = "false";
      push.default = "simple";
    };

    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };
  };

  home.packages = [pkgs.git-extras];
  home.sessionVariables.LESS = "-r";
}
