{ pkgs, ... }:

{
  # Custom packages
  # default = pkgs.callPackage ./default { };

  nivel-modpack-server = pkgs.callPackage ./minecraft/modpack {
    side = "server";
    packHash = "sha256-J4BdDxa9/48r/xrzNuozvvSMcNkLrmXBmZgmYC6YdPo=";
  };
  nivel-modpack-client = pkgs.callPackage ./minecraft/modpack {
    side = "client";
    packHash = "sha256-+gPpaV1Oh23Jc/LdcoYbUm3hyYJmoTjd7tXxU9gjMkM=";
  };
}
