{
  pkgs,
  lib,
  config,
  ...
}:
{
  languages.javascript.enable = true;
  languages.javascript.pnpm.enable = true;
  languages.javascript.pnpm.install.enable = true;
}
