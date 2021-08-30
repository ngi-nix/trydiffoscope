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
          { trydiffoscope = self.defaultPackage.${system}; }
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

        apps = mapAttrs (_: v:
          mapAttrs (_: a:
            {
              type = "app";
              program = a;
            }
          ) v
        ) self.packages;

        defaultApp = mapAttrs (_: v:
          v.trydiffoscope
        ) self.apps;

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
