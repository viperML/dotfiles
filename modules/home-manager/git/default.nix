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
    glab
    delta
    gh
  ];

  home.sessionVariables.LESS = "-r";
}
