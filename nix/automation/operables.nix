{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;
  inherit (inputs.cells.lib) lib;
  l = nixpkgs.lib // builtins;

  package = cell.packages.hello;
in {
  hello = std.lib.ops.mkOperable {
    inherit package;
    debugInputs = lib.containerCommonDebug;
    runtimeInputs = with nixpkgs; [
      busybox # Includes nslookup
    ];
    runtimeScript = ''
      echo ">>> Entering entrypoint script..."

      echo "Starting hello"
      ${package}/bin/hello
      while true; do
        echo ">>> Sleeping..."
        sleep 1
      done
    '';
  };
}