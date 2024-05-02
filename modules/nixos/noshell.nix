{inputs', ...}: let
  pkg = inputs'.noshell.packages.default;
in {
  environment.shells = [pkg];

  environment.systemPackages = [pkg];

  users.users."foo" = {
    isNormalUser = true;
    shell = pkg;
  };
}
