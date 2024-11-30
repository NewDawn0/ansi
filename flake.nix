{
  description = "A cheatsheet for ansi escape codes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nix-systems.url = "github:nix-systems/default";
  };
  outputs = { nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import inputs.nix-systems);
      mkPkgs = system: nixpkgs.legacyPackages.${system};
    in {
      packages = eachSystem (system:
        let pkgs = mkPkgs system;
        in {
          default = pkgs.stdenv.mkDerivation {
            name = "ansi";
            version = "1.0.0";
            src = ./.;
            buildInputs = [ pkgs.zig ];
            buildPhase = ''
              export LIBRARY_PATH=/usr/lib
              export DYLD_LIBRARY_PATH=/usr/lib
              cacheDir=$(mktemp -d)
              zig build --global-cache-dir $cacheDir
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp zig-out/bin/ansi $out/bin
            '';
            meta = with pkgs.lib; {
              description = "A cheatsheet for ansi escape codes";
              homepage = "https://github.com/NewDawn0/ansi";
              license = licenses.mit;
              maintainers = [ NewDawn0 ];
              platforms = platforms.all;
            };
          };
        });
    };
}
