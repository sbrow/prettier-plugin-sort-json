{
  description = "A prettier plugin to sort json objects by key";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ self
    , flake-parts
    , nixpkgs
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { inputs', pkgs, system, ... }:
        let
          typescript = pkgs.typescript;
        in
        {
          formatter = pkgs.nixpkgs-fmt;

          devShells.default = pkgs.mkShell
            {
              buildInputs = [
                typescript
                pkgs.yarn
              ];
            };

          packages.default = pkgs.stdenv.mkDerivation {
            name = "pretter-plugin-sort-json";
            version = "4.0.0";

            buildInputs = [ typescript ];

            src = ./.;

            buildPhase = ''
              export HOME=$(pwd)
              tsc --project tsconfig.build.json
            '';

            installPhase = ''
              mkdir -p $out/lib
              cp dist/* $out/lib
            '';
          };
        };
    };
}
