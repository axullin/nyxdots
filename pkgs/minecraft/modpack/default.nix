{
  fetchPackwizModpack,
  src,
  side,
  packHash,
}:
let
  pack = builtins.fromTOML (builtins.readFile (src + "/pack.toml"));

  modpack = fetchPackwizModpack {
    inherit src side packHash;
    pname = "nivel-modpack-${side}";
    inherit (pack) version;
  };
in
modpack.overrideAttrs (previous: {
  passthru = previous.passthru // {
    loaderVersion = pack.versions.fabric;
    minecraftVersion = pack.versions.minecraft;
  };
})
