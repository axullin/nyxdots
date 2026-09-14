{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        prismlauncher
        (olympus.override {
          celesteWrapper = "steam-run";
        })
      ];
    };
}
