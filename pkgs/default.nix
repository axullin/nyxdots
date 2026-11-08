{ pkgs, inputs, ... }:

{
  # Custom packages
  # default = pkgs.callPackage ./default { };

  nivel-modpack-server = pkgs.callPackage ./minecraft/modpack {
    src = "${inputs.modpacks}/nivel/pack";
    side = "server";
    packHash = "sha256-4Ggm0MrgLgz4V+35xEwlnqHP3VQbg7PN2WcBVs2v78c=";
  };
  nivel-modpack-client = pkgs.callPackage ./minecraft/modpack {
    src = "${inputs.modpacks}/nivel/pack";
    side = "client";
    packHash = "sha256-8/P/xwjmaj6S3A9bKAHr/X+mriS0m48BhCzV82JhBVU=";
  };
}
