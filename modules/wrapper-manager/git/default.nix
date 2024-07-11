{pkgs, ...}: {
  wrappers.git = {
    basePackage = pkgs.gitFull;
    extraPackages = [pkgs.git-extras];
    env.GIT_CONFIG_GLOBAL.value = ../../../misc/gitconfig;
  };
}
