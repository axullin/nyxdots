{
  flake.modules.nixos.core =
    { userName, ... }:
    {
      nix = {
        channel.enable = false;

        # programs.nh.clean owns generation cleanup, and asserts this stays off.
        gc.automatic = false;

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
