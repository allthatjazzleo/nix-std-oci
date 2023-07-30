{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  hello = nixpkgs.hello;
}