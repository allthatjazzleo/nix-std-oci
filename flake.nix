{
  description = "A very basic std flake to build docker image";


  inputs = {

    n2c = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    std = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.n2c.follows = "n2c";
      url = "github:divnix/std";
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
