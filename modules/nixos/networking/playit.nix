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

      config = lib.mkIf config.nyx.networking.mc-server.enable {
        services.playit = {
          enable = true;
          secretPath = "/persist/playit/secret.toml";
        };

        nix.settings = {
          extra-substituters = [
            # playit.gg NixOS module binary cache
            "https://playit-nixos-module.cachix.org"
          ];
          extra-trusted-public-keys = [
            # playit.gg NixOS module binary cache
            "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
          ];
        };
      };
    };
}
