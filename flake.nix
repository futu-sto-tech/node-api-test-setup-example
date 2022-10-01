{
  description = "A Node project flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs
              nodePackages.typescript-language-server
            ];

            shellHook = ''
              export PATH="$(pwd)/node_modules/.bin:$PATH"
            '';
          };
        });
}
