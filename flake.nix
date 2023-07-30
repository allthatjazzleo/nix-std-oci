{
  description = "A very basic std flake to build docker image";


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    std = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:divnix/std";
      inputs.devshell.follows = "devshell";
      inputs.nixago.follows = "nixago";
    };
  };

  outputs = {
    std,
    self,
    ...
  } @ inputs:
    std.growOn {
      inherit inputs;

      cellsFrom = ./nix;

      cellBlocks = with std.blockTypes; [
        (installables "packages")
        (containers "containers")
        (functions "lib")
        (runnables "operables")
      ];

      nixpkgsConfig = {
        # Nixpkgs configuration applied to inputs.nixpkgs
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        allowUnsupportedSystem = true;
      };
    }
    {
      containers = std.harvest self [
        ["automation" "containers"]
      ];
      packages = std.harvest self [
        ["automation" "packages"]
      ];
    };

}
