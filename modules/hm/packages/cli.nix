{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        agent-browser
        ast-grep
        btop
        jq
        tmux
        tree
        unzip
        yazi
        zip
      ];
    };
}
