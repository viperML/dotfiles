{
  symlinkJoin,
  makeWrapper,
  helix,
  writeTextDir,
  formats,
  lib,
  runCommandNoCC,
}:
with builtins; let
  tomlFormat = formats.toml {};
  files = {
    "config.toml" = tomlFormat.generate "config.toml" {
      theme = "base16_terminal";
      editor = {
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
    "languages.toml" = tomlFormat.generate "languages.toml" {
      language = [
        {
          language-server.command = "rnix-lsp";
          name = "nix";
        }
      ];
    };
  };

  dir = runCommandNoCC "helix-config" {} ''
    mkdir -p $out/helix
    ${lib.concatStringsSep "\n" (attrValues (mapAttrs (n: v: "cp -vf ${v} $out/helix/${n}") files))}
  '';
in
  symlinkJoin {
    inherit (helix) name pname version;
    paths = [helix];
    nativeBuildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/hx \
        --set XDG_CONFIG_HOME ${dir}
    '';
  }
