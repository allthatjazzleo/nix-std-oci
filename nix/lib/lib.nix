{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;
  l = nixpkgs.lib // builtins;
in rec {
  containerCommon = {
    uid = "1000";
    gid = "1000";

    setup = let
      setupEnv =
        std.lib.ops.mkSetup "container"
        [
          {
            regex = "/tmp";
            mode = "0777";
          }
        ]
        ''
          # Enable nix flakes
          mkdir -p $out/etc
          echo "sandbox = false" > $out/etc/nix.conf
          echo "experimental-features = nix-command flakes" >> $out/etc/nix.conf

          # Put local profile in path
          echo 'export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"' >> $out/etc/bashrc
        '';
    in [setupEnv];

    options = {
      initializeNixDatabase = true;
      nixUid = 1000;
      nixGid = 1000;

      config = {
        Env = [
          # Required by many tools
          "HOME=/home/user"
          # Nix related environment variables
          "NIX_CONF_DIR=/etc"
          "NIX_PAGER=cat"
          # This file is created when nixpkgs.cacert is copied to the root
          "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
          # Nix expects a user to be set
          "USER=user"
          # Include <nixpkgs> to support installing additional packages
          "NIX_PATH=nixpkgs=${nixpkgs.path}"
        ];
      };
    };
  };

  # The OCI registry we are pushing to
  registry = "ghcr.io/allthatjazzleo/nix-std-oci";
  
  labels = {
    # The OCI registry we are pushing to
    source = https://github.com/allthatjazzleo/nix-std-oci;
  };
}
