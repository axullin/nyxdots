{
  flake.modules.homeManager.terminal = {
    programs.tmux = {
      enable = true;
      clock24 = true;
      mouse = true;
      historyLimit = 10000;
      escapeTime = 10;
    };
  };
}
