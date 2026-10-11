{ pkgs, ... }:

{
  # Custom packages
  # default = pkgs.callPackage ./default { };

  nivel-modpack-server = pkgs.callPackage ./minecraft/modpack {
    side = "server";
    packHash = "sha256-OwFu75JgpRLN2dXUDDhwSezLFbYmPZMow1cFr5aCZZo=";
  };
  nivel-modpack-client = pkgs.callPackage ./minecraft/modpack {
    side = "client";
    packHash = "sha256-/Ubz87YlZDuuUb8L1jMrebhxo3zcTDwqFsAd4LTF5w0=";
  };
}
