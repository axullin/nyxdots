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
      ollama = lib.getExe pkgs.ollama-rocm;

      qwen16gbModelfile = pkgs.writeText "qwen3.8-16gb.Modelfile" ''
        FROM smtek/Qwen3.8-27B:Q3_K_M
        PARAMETER num_ctx 262144
      '';
    in
    {
      options.nyx.ai.ollama = {
        enable = lib.mkEnableOption "Ollama for local models on the AMD GPU";
      };

      config = lib.mkIf cfg.enable {
        services.ollama = {
          enable = true;
          package = pkgs.ollama-rocm;

          environmentVariables = {
            OLLAMA_CONTEXT_LENGTH = "32768";
            LLAMA_ARG_KV_OFFLOAD = "0";
          };
        };

        systemd.services.ollama-qwen-16gb = {
          description = "Pull Qwen3.8 Q3 and register a 256k context";
          wantedBy = [ "multi-user.target" ];
          wants = [ "network-online.target" ];
          after = [
            "ollama.service"
            "network-online.target"
          ];
          bindsTo = [ "ollama.service" ];
          environment = config.systemd.services.ollama.environment;
          serviceConfig = {
            Type = "exec";
            DynamicUser = true;
            Restart = "on-failure";
            RestartSec = "5s";
          };
          script = ''
            set -eu
            for _ in $(seq 1 60); do
              if ${ollama} list >/dev/null 2>&1; then
                break
              fi
              sleep 1
            done
            ${ollama} pull smtek/Qwen3.8-27B:Q3_K_M
            ${ollama} create qwen3.8-16gb -f ${qwen16gbModelfile}
          '';
        };

        environment.systemPackages = [ pkgs.rocmPackages.rocminfo ];
      };
    };
}
