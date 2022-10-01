{
  description = "A Node project flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    npm-buildpackage = {
      url = "github:serokell/nix-npm-buildpackage";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, npm-buildpackage }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        bp = pkgs.callPackage npm-buildpackage {};
        app = bp.buildNpmPackage {
          src = ./.;
        };
      in
        {
          packages.${app.pname} = app;

          packages.docker = pkgs.dockerTools.buildLayeredImage {
            name = app.pname;
            tag = app.version;
            contents = [ app pkgs.cacert pkgs.nodejs ];
            config = {
              Env = [
                "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.txt"
                "APP_HOST=0.0.0.0"
                "APP_PORT=8080"
              ];
              Entrypoint = [ "node" "${app}/src/server.js" ];
              ExposedPorts = {
                "8080/tcp" = {};
              };
            };
          };

          defaultPackage = self.packages.${system}.${app.pname};

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
