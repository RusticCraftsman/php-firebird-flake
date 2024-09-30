{
  description = "A flake for building php-firebird";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          php-firebird = pkgs.callPackage ./php-firebird { };
        }
      );

      defaultPackage = forAllSystems (system: self.packages.${system}.php-firebird);

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          phpWithFirebird = pkgs.php.withExtensions ({ enabled, all }: enabled ++ [ self.packages.${system}.php-firebird ]);
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              phpWithFirebird
            ];
          };
        }
      );
    };
}
