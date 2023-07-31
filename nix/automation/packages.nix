{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs n2c;
in {
  hello = nixpkgs.aarch64-linux.hello;
}