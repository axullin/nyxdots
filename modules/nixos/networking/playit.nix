{
  flake.modules.nixos.networking =
    {
      config,
      lib,
      inputs,
      ...
    }:
    {
      imports = [ inputs.playit.nixosModules.default ];

      options.nyx.networking.playit.enable = lib.mkEnableOption "the playit.gg tunnel";

      config = lib.mkIf config.nyx.networking.playit.enable {
        services.playit = {
          enable = true;
          secretPath = "${config.nyx.impermanence.prefix}/playit/secret.toml";
        };

        nix.settings = {
          extra-substituters = [
            "https://playit-nixos-module.cachix.org"
          ];
          extra-trusted-public-keys = [
            "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
          ];
        };
      };
    };
}
