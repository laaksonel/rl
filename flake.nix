{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:

    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      libs = [ pkgs.stdenv.cc.cc.lib pkgs.zlib ];
    in
    {
      devShells.default = pkgs.mkShell {
        buildInputs = libs;
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libs;

        packages = [
          pkgs.pipenv
          (pkgs.python312.withPackages (python-pkgs: [
            python-pkgs.pip
            #python-pkgs.jupyterlab
          ]))
        ];
      };
    });
}
