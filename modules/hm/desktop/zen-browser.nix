{
  flake.modules.homeManager.desktop =
    { inputs, ... }:
    {
      imports = [ inputs.zen-browser.homeModules.beta ];

      nyx.impermanence.directories = [ ".config/zen" ];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = false;
      };
    };
}
