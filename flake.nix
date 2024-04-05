{
  description = "astro-pnpm-sharp";

  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        packages.default = pkgs.nodePackages.pnpm;

        devenv.shells.default = {
          env = {ASTRO_SITE = "http://localhost:3000";};

          packages = with pkgs; [
            vips
            libavif
            libjpeg
            libpng
            libwebp
            pngcrush
          ];

          processes.astro.exec = "pnpm dev";

          languages.javascript.enable = true;
          languages.javascript.pnpm.enable = true;
          languages.python.enable = true;
        };
      };
    };
}
