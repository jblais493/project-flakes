# Go/Templ/Datastar/Tailwind Flake Template

## Running Development Environment
This runs air/templ/tailwind watch:

``` sh
overmind start
```

## Building App 

``` sh
nix build
```

You will be given a vendor hash, replace this line in flake.nix:

``` nix
vendorHash = pkgs.lib.fakeHash;
```

with:

``` nix
vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
```
