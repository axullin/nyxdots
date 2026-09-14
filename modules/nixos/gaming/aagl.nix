{
  flake.modules.nixos.gaming =
    {
      config,
      lib,
      inputs,
      ...
    }:
    let
      cfg = config.nyx.gaming.aagl;
      launcherOptions = description: {
        enable = lib.mkEnableOption description;
      };
    in
    {
      imports = [ inputs.aagl.nixosModules.default ];

      options.nyx.gaming.aagl = {
        enable = lib.mkEnableOption "AAGL (Anime Game Team launchers via aagl-gtk-on-nix)";

        "anime-game-launcher" = launcherOptions "Genshin Impact launcher";
        "honkers-railway-launcher" = launcherOptions "Honkai: Star Rail launcher";
        "honkers-launcher" = launcherOptions "Honkai Impact 3rd launcher";
        "sleepy-launcher" = launcherOptions "Zenless Zone Zero launcher";
        "wavey-launcher" = launcherOptions "Wuthering Waves launcher";
        "anime-games-launcher" = launcherOptions "Umbrella anime-games launcher";
      };

      config = lib.mkIf cfg.enable {
        # Upstream main tracks nixpkgs 26.11; disable if unstable's release string differs.
        aagl.enableNixpkgsReleaseBranchCheck = false;

        programs = {
          anime-game-launcher.enable = cfg."anime-game-launcher".enable;
          honkers-railway-launcher.enable = cfg."honkers-railway-launcher".enable;
          honkers-launcher.enable = cfg."honkers-launcher".enable;
          sleepy-launcher.enable = cfg."sleepy-launcher".enable;
          wavey-launcher.enable = cfg."wavey-launcher".enable;
          anime-games-launcher.enable = cfg."anime-games-launcher".enable;
        };

        nix.settings = {
          extra-substituters = [
            # AAGL / anime-game-launcher binary cache
            "https://ezkea.cachix.org"
          ];
          extra-trusted-public-keys = [
            # AAGL / anime-game-launcher binary cache
            "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
          ];
        };
      };
    };
}
