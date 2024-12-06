{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs; [
          bat
          bottom
          chezmoi
          cloc
          fd
          fish
          flyctl
          go-task
          ripgrep
          shfmt
          typos

          # nix
          nil
          nixpkgs-fmt

          # kerl
          jdk
          wxGTK32
          openssl
          unixODBC
          fop

          # data format
          jq
          yq

          # git
          git-delete-merged-branches
          git-lfs
          lazygit

          # env
          direnv
          dotenvx
          mise

          # network
          dnstop
          doggo
        ];

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        ### added
        environment.variables = {
          SSLDEV = "${pkgs.openssl.dev}";
          SSLOUT = "${pkgs.openssl.out}";
          ODBCOUT = "${pkgs.unixODBC.out}";
        };

        environment.shellAliases = {
          lg = "lazygit";
          t = "task -g";
        };
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
}
