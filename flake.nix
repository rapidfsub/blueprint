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
          fzf
          go-task
          ripgrep
          shfmt
          typos
          zoxide
          zsh-autocomplete

          # nix
          nil
          nixpkgs-fmt

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
        environment.shellAliases = {
          lg = "lazygit";
          t = "task";
        };

        security.pam.enableSudoTouchIdAuth = true;

        system.defaults.NSGlobalDomain = {
          AppleICUForce24HourTime = true;
          ApplePressAndHoldEnabled = false;
          AppleShowAllExtensions = true;
          # from 15 to 120
          InitialKeyRepeat = 15;
          # from 2 to 120
          KeyRepeat = 1;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
        };

        system.defaults.dock = {
          autohide = true;
          mru-spaces = false;
          orientation = "left";
          persistent-apps = [ ];
          persistent-others = [ ];
          show-process-indicators = false;
          show-recents = false;
          showhidden = true;
          static-only = true;
          tilesize = 48;
        };

        system.defaults.CustomUserPreferences = {
          "~/Library/Preferences/ByHost/com.apple.controlcenter.plist" = {
            "AccessibilityShortcuts" = 9;
            "AirDrop" = 24;
            "Battery" = 9;
            "BatteryShowPercentage" = 0;
            "Bluetooth" = 8;
            "Display" = 8;
            "FocusModes" = 8;
            "Hearing" = 9;
            "KeyboardBrightness" = 9;
            "MusicRecognition" = 9;
            "NowPlaying" = 8;
            "ScreenMirroring" = 8;
            "Sound" = 8;
            "StageManager" = 8;
            "UserSwitcher" = 9;
            "WiFi" = 24;
          };
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
