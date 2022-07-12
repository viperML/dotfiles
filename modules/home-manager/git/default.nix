{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    includes = [
      {
        path = ./includes;
      }
    ];
  };

  home.packages = with pkgs; [
    git-extras
    gibo
    glab
    delta
    gh
  ];

  home.sessionVariables.LESS = "-r";
}
