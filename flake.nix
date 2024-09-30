{
  description = "PHP Firebird extension flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
        php-with-firebird = pkgs.php.withExtensions ({ all, ... }: [ all.firebird ]);
      in
      {
        packages.default = php-with-firebird;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            php-with-firebird
          ];
        };
      }
    ) // {
      overlay = final: prev: {
        phpExtensions = prev.phpExtensions // {
          firebird = final.callPackage ./firebird.nix { };
        };
      };
    };
}
