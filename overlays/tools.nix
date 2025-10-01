_inputs: _final: prev: let
  listToAttrs = list:
    builtins.listToAttrs (
      map (v: {
        name = v."pname" or v."name";
        value = v;
      })
      list
    );
  lib = prev.lib;
  packages = lib.pipe (lib.filesystem.listFilesRecursive ../tools) [
    (builtins.filter (name: lib.hasSuffix "package.nix" name))
    (builtins.map (name: prev.callPackage name {}))
    listToAttrs
  ];
in {
  tools = packages;
}
