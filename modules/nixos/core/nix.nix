{
  flake.modules.nixos.core =
    {
      userName,
      ...
    }:
    {
      nyx.impermanence.home.directories = [ ".cache/nix" ];

      nix = {
        channel.enable = false;

        gc = {
          automatic = true;
          dates = "weekly";
          persistent = true;
          randomizedDelaySec = "45min";
          options = "--delete-older-than 7d";
        };

        optimise.automatic = true;

        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          max-jobs = "auto";
          use-xdg-base-directories = true;
          http-connections = 128;
          max-substitution-jobs = 128;
          log-lines = 25;
          min-free = 128000000; # 128 MB
          max-free = 1000000000; # 1 GB
          keep-outputs = true;
          keep-derivations = true;
          keep-going = false;
          warn-dirty = false;
          connect-timeout = 5;
          builders-use-substitutes = true;
          fallback = true;

          trusted-users = [
            "root"
            "${userName}"
          ];
          allowed-users = [
            "root"
            "${userName}"
          ];

        };
      };
    };
}
