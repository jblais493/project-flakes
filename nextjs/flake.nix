{
  description = "Next.js development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Node.js ecosystem
            nodejs_22
            nodePackages.pnpm

            # Build essentials (required for native node modules)
            gcc
            gnumake
            python3

            # Next.js often needs these for image optimization
            vips
            pkg-config

            # Deployment tools (since your script uses these)
            podman
            openssh
            curl
          ];

          shellHook = ''
            echo "🚀 Next.js development environment activated"
            echo "Node: $(node --version)"
            echo "pnpm: $(pnpm --version)"

            # Set pnpm store to local directory for reproducibility
            export PNPM_HOME="$PWD/.pnpm"
            export PATH="$PNPM_HOME:$PATH"

            # Ensure clean builds
            export NODE_ENV=development

            # Tell Next.js to use more memory if needed
            export NODE_OPTIONS="--max-old-space-size=4096"
          '';
        };
      }
    );
}
