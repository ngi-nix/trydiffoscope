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
      with nixpkgs.lib;
      {
        overlays.trydiffoscope = final: prev:
          {
            trydiffoscope = prev.callPackage ./trydiffoscope.nix {};
          };

        overlay = self.overlays.trydiffoscope;

        packages = forAllSystems (system:
          { bitmask-vpn = self.defaultPackage.${system}; }
        );

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

        devShell = forAllSystems (system:
          let
            pkgs = import nixpkgs
              { inherit system;
                overlays = mapAttrsToList (_: id) self.overlays;
              };
          in
            pkgs.mkShell {
              nativeBuildInputs = with pkgs;
                [ which
                  (python3.withPackages (pkgs: with pkgs; [ requests ]))
                ];
            }
        );
      };
}
