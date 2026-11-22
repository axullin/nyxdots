{
  flake.modules.nixos.hardware =
    { pkgs, ... }:
    {
      # Selected audio devices
      nyx.impermanence.home.directories = [ ".local/state/wireplumber" ];

      security.rtkit.enable = true;

      # Run JACK apps through the `pw-jack` wrapper instead of services.pipewire.jack
      environment.systemPackages = [ pkgs.pipewire.jack ];

      services.pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        wireplumber.enable = true;

        extraConfig.pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.allowed-rates" = [
              44100
              48000
              88200
              96000
              176400
              192000
              352800
              384000
            ];
            "default.clock.quantum" = 64;
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 2048;
          };
        };

        extraConfig.pipewire-pulse."92-low-latency" = {
          "pulse.properties" = {
            "pulse.min.req" = "64/48000";
            "pulse.min.quantum" = "64/48000";
          };
        };

        wireplumber.extraConfig."10-fiio-k11" = {
          "monitor.alsa.rules" = [
            {
              matches = [ { "device.name" = "~alsa_card.*K11.*"; } ];
              actions.update-props = {
                "api.alsa.use-acp" = false;
                "audio.format" = "S32LE";
                "audio.allowed-rates" = "44100,48000,88200,96000,176400,192000,352800,384000";
              };
            }
            {
              matches = [ { "node.name" = "~alsa_output.*K11.*"; } ];
              actions.update-props = {
                "api.alsa.period-size" = 256;
                "session.suspend-timeout-seconds" = 0;
                "audio.channels" = 2;
                "audio.position" = [
                  "FL"
                  "FR"
                ];
              };
            }
          ];
        };
      };
    };
}
