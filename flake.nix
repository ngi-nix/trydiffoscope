{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { nixpkgs, self }@inputs:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems' = systems: fun: nixpkgs.lib.genAttrs systems fun;
      forAllSystems = forAllSystems' supportedSystems;
    in
    {
      overlays.trydiffoscope = final: prev:
        {
          trydiffoscope = prev.callPackage ./trydiffoscope.nix {};
        };

      defaultPackage = forAllSystems (system:
        let
          pkgs = import nixpkgs
            { inherit system;
              overlays = [ self.overlays.trydiffoscope ];
              config.allowUnfree = true;
            };
        in
          pkgs.trydiffoscope
      );
    };
}
