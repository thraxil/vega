{ sources ? import ./sources.nix
, pkgs ? import sources.nixpkgs { }
}:

with pkgs;

buildEnv {
  name = "builder";
  paths = [
    beam.packages.erlangR27.elixir_1_19
    flyctl
    git
    nodejs
    postgresql
  ];
}
