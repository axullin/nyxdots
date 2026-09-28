{
  fetchPackwizModpack,
  side,
  packHash,
}:

# The pack sources live in ./pack. This builds them once for the given side.
# After any pack change, update both hashes in pkgs/default.nix. Set a wrong
# hash, build, and copy the `got:` line from the mismatch.
#
# The name includes the side. Without that, both builds inherit the name from
# pack.toml, and a hash pasted onto the wrong side resolves to the other
# build's store path instead of failing.
let
  pack = builtins.fromTOML (builtins.readFile ./pack/pack.toml);

  modpack = fetchPackwizModpack {
    src = ./pack;
    inherit side packHash;
    pname = "nivel-modpack-${side}";
    inherit (pack) version;
  };
in
# fetchPackwizModpack already sets passthru, and passing another one in would
# replace it. overrideAttrs is how the loader version gets added on top.
# mc-server.nix reads loaderVersion so the server stays on the pack's loader.
modpack.overrideAttrs (previous: {
  passthru = previous.passthru // {
    loaderVersion = pack.versions.fabric;
    minecraftVersion = pack.versions.minecraft;
  };
})
