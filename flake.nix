{
  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
  description = "Interpreters for org-roam notes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      emacs-overlay,
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem =
        {
          pkgs,
          self',
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              emacs-overlay.overlays.default
              (final: prev: {
                emacs = prev.emacsWithPackagesFromPackageRequires {
                  package = prev.emacs-unstable-nox;
                  packageElisp = builtins.readFile ./publish.el;
                };
              })
            ];
          };
          packages.default = pkgs.callPackage ./nix/publish.nix { src = ./.; };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              haskell-language-server
              yaml-language-server
              (haskellPackages.ghcWithPackages (
                hs: with hs; [
                  singletons
                  singletons-th
                ]
              ))
            ];
          };
        };
    };
}
