{
  description = "Go/templ/tailwind development environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = self.packages.${system}.compline;
          compline = pkgs.buildGoModule {
            pname = "compline";
            version = "0.1.0";
            src = ./.;
            vendorHash = pkgs.lib.fakeHash;

            nativeBuildInputs = with pkgs; [
              templ
              tailwindcss
            ];

            preBuild = ''
              templ generate
              tailwindcss -i ./ui/css/main.css -o ./public/tailwind.css --minify
            '';

            postInstall = ''
              mkdir -p $out/share/appName/public
              cp -r public/* $out/share/appName/public/
            '';

            subPackages = [ "cmd/web" ];
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            go
            gopls
            gotools
            go-tools
            templ
            air
            tailwindcss
            overmind
          ];

          shellHook = ''
            echo "Go/Templ/Datastar/Tailwind Development Environment"
            echo ""
            echo "Commands:"
            echo "  overmind start    - Start all watchers"
            echo "  nix build         - Production build"
            echo "  nix run           - Run production binary"
            echo ""
            mkdir -p tmp public bin
          '';
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/web";
        };
      }
    );
}
