{
  flake.modules.nixos.ai =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.nyx.ai.ollama;
    in
    {
      options.nyx.ai.ollama = {
        enable = lib.mkEnableOption "Ollama for local models on the AMD GPU";
      };

      # Navi 44 (RX 9060 XT) is gfx1200, a native ROCm 7.2 target.
      # No HSA_OVERRIDE_GFX_VERSION: that spoofs a different chip.
      config = lib.mkIf cfg.enable {
        services.ollama = {
          enable = true;
          package = pkgs.ollama-rocm;

          # Default window is 4096. OpenCode's prompt already exceeds that,
          # and the server then drops earlier messages.
          environmentVariables.OLLAMA_CONTEXT_LENGTH = "32768";
        };

        environment.systemPackages = [ pkgs.rocmPackages.rocminfo ];
      };
    };
}
