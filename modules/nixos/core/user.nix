{
  flake.modules.nixos.core =
    {
      config,
      pkgs,
      lib,
      userName,
      ...
    }:
    let
      impermanence = config.nyx.impermanence;
    in
    {
      programs.fish.enable = true;

      time.timeZone = "Europe/Warsaw";
      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocales = [ "pl_PL.UTF-8/UTF-8" ];
        extraLocaleSettings = lib.genAttrs [
          "LC_ADDRESS"
          "LC_IDENTIFICATION"
          "LC_MEASUREMENT"
          "LC_MONETARY"
          "LC_NAME"
          "LC_NUMERIC"
          "LC_PAPER"
          "LC_TELEPHONE"
          "LC_TIME"
        ] (_: "en_US.UTF-8");
      };

      users = {
        mutableUsers = !impermanence.enable;
        defaultUserShell = pkgs.fish;
        users.${userName} = {
          hashedPasswordFile = lib.mkIf impermanence.enable "${impermanence.path}/passwords/${userName}";
          isNormalUser = true;
          extraGroups = [
            "networkmanager"
            "wheel"
            "storage"
            "input"
            "video"
          ];
        };
      };
    };
}
