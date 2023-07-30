{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;
  inherit (inputs.cells.lib) lib;
  l = nixpkgs.lib // builtins;

  operable = cell.operables.hello;
in {
  hello = let
    rev =
      if (inputs.self.rev != "not-a-commit")
      then inputs.self.rev
      else "";
  in
    std.lib.ops.mkStandardOCI ({
        inherit operable;
        inherit (lib) labels;
        name = "${lib.registry}";
        debug = true;
      }
      # Include common container setup
      // lib.containerCommon
      # Default to using output hash as the tag if the repo is dirty
      // l.optionalAttrs (rev != "") {tag = rev;});
}
