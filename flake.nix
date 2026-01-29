{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = {
    nixpkgs,
    ...
  }: let
  systems = nixpkgs.lib.systems.flakeExposed;
    forAllSystems = nixpkgs.lib.genAttrs systems;
    pkgsFor = system: nixpkgs.legacyPackages.${system};
    beamFor = system: (pkgsFor system).beam.packages.erlang_26;
  in {
    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
      beam = beamFor system;
    in {
      default = pkgs.mkShell {
        packages = builtins.attrValues {
          inherit (pkgs) git gh nixd alejandra mix2nix sqld cargo rustc cmake;
          inherit (beam) elixir;
        };
      };
    });
  };
}
