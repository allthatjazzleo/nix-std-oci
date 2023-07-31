{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;
  inherit (inputs.cells.lib) lib;
  l = nixpkgs.lib // builtins;

  package = cell.packages.hello;
  runtimeShell = nixpkgs.aarch64-linux.bash;
in {
  hello = std.lib.ops.mkOperable {
    inherit package runtimeShell;
    runtimeInputs = with nixpkgs; [
      aarch64-linux.coreutils # Includes nslookup
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