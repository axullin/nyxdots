{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    let
      cfg = config.nyx.desktop.noctalia;
    in
    {
      imports = [ inputs.noctalia.nixosModules.default ];

      options.nyx.desktop.noctalia = {
        enable = lib.mkEnableOption "the Noctalia desktop shell";
      };

      config = lib.mkIf cfg.enable {
        programs.noctalia = {
          package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          recommendedServices.enable = true;
        };

        nix.settings = {
          extra-substituters = [
            # Noctalia desktop shell binary cache
            "https://noctalia.cachix.org"
          ];
          extra-trusted-public-keys = [
            # Noctalia desktop shell binary cache
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
        };
      };
    };
}
