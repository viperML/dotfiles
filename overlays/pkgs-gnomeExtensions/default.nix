final: prev: let
  inherit (prev) callPackage;
in {
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      tidalwm = callPackage ./tidalwm {};
    };
}
