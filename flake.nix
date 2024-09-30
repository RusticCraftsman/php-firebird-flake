{
  description = "PHP Firebird extension flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    overlay = final: prev: {
      phpExtensions = prev.phpExtensions // {
        firebird = final.callPackage ./firebird.nix { };
      };
    };
  };
}
