{
  description = "A cheatsheet for ansi escape codes";

  inputs.utils.url = "github:NewDawn0/nixUtils";

  outputs = { self, utils, ... }: {
    overlays.default = final: prev: {
      ansi = self.packages.${prev.system}.default;
    };
    packages = utils.lib.eachSystem { } (pkgs: {
      default = pkgs.stdenv.mkDerivation {
        pname = "ansi";
        version = "1.0.0";
        src = ./.;
        buildInputs = with pkgs; [ zig ];
        buildPhase = ''
          ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
            # On Darwin the executable needs to link to libSystem
            export LIBRARY_PATH="$(xcrun --show-sdk-path)/usr/lib"
            export DYLD_LIBRARY_PATH="$(xcrun --show-sdk-path)/usr/lib"
          ''}
          cacheDir=$(mktemp -d)
          zig build --global-cache-dir $cacheDir
        '';
        installPhase = "install -D zig-out/bin/ansi -t $out/bin";
        meta = {
          description = "Quick reference guide for ANSI escape codes";
          longDescription = ''
            Handy cheatsheet for quickly looking up ANSI escape codes.
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
