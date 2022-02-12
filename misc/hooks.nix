{ inputs
, system
}:
{
  alejandra = {
    enable = true;
    name = "Format nix";
    entry = "${inputs.alejandra.defaultPackage.${system}}/bin/alejandra";
    files = "\\.nix$";
    excludes = [ "deps\\.nix" ];
  };
}
