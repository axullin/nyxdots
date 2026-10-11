{
  flake.modules.nixos.desktop =
    { pkgs, inputs, ... }:
    {
      imports = [ inputs.noctalia.nixosModules.default ];

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
}
