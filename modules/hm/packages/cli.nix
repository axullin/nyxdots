{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        agent-browser
        ast-grep
        btop-rocm
        jq
        tree
        unzip
        yazi
        zip
      ];
    };
}
