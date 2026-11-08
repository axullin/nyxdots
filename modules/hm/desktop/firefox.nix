{
  flake.modules.homeManager.desktop =
    { inputs, pkgs, ... }:
    let
      addons = (pkgs.extend inputs.firefox-addons.overlays.default).firefox-addons;
    in
    {
      programs.firefox = {
        enable = true;
        configPath = ".mozilla/firefox";
        nativeMessagingHosts = [ pkgs.tridactyl-native ];

        profiles.default = {
          id = 0;
          isDefault = true;
          settings."extensions.autoDisableScopes" = 0;
          extensions.packages = with addons; [
            ublock-origin
            darkreader
            sponsorblock
            dearrow
            istilldontcareaboutcookies
            multi-account-containers
            refined-github
            tridactyl
            youtube-recommended-videos
          ];
        };
      };

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
        };
      };

      xdg.configFile."tridactyl/tridactylrc".text = "";
    };
}
