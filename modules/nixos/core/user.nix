{
  flake.modules.nixos.core =
    {
      pkgs,
      lib,
      userName,
      ...
    }:
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
        mutableUsers = false;
        defaultUserShell = pkgs.fish;
        users.${userName} = {
          hashedPasswordFile = "/persist/passwords/${userName}";
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
