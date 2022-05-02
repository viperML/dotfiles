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
      core.excludesfile =
        (pkgs.writeText "gitignore" ''
          result
          .direnv
          *.qcow2
          node_modules
          .venv
          *~
          \#*\#
          .DS_Store
          Thumbs.db
        '')
        .outPath;
    };
    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings = {
      git_protocol = "https";
      pager = "bat";
    };
  };

  home.packages = with pkgs; [
    git-extras
    gibo
  ];
  home.sessionVariables.LESS = "-r";
}
