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
            pname = "ansi";
            version = "1.0.0";
            src = ./.;
            buildInputs = with pkgs; [ zig ];
            buildPhase = ''
              ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
                # On Darwin the executable needs to link to libSystem found in /usr/lib/
                export LIBRARY_PATH=/usr/lib
                export DYLD_LIBRARY_PATH=/usr/lib
              ''}
              cacheDir=$(mktemp -d)
              zig build --global-cache-dir $cacheDir
            '';
            installPhase = "install -D zig-out/bin/ansi -t $out/bin";
            meta = {
              description = "A quick reference guide for ANSI escape codes";
              longDescription = ''
                A handy cheatsheet for quickly looking up ANSI escape codes.
                Perfect for developers working with terminal color codes and text formatting.
              '';
              homepage = "https://github.com/NewDawn0/ansi";
              license = pkgs.lib.licenses.mit;
              maintainers = with pkgs.lib.maintainers; [ NewDawn0 ];
              platforms = pkgs.lib.platforms.all;
            };
          };
        });
    };
}
