{
  description = "Vulkan HDR Layer Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: {
    packages.default = self.packages.x86_64-linux.vk-hdr-layer;
    packages.x86_64-linux.vk-hdr-layer =
      let pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      in pkgs.stdenv.mkDerivation rec {
        pname = "vulkan-hdr-layer";
        version = "63d2eec";
      
        src = (nixpkgs.fetchFromGitHub {
          owner = "Drakulix";
          repo = "VK_hdr_layer";
          rev = "63d2eeccb962824c90e158a06900ae1abec9c49e";
          fetchSubmodules = true;
          hash = "sha256-IwHrMTiOzITMsGMZN/AuUN3PF/oMhENw9d7kX2VnDGM=";
        }).overrideAttrs (_: {
          GIT_CONFIG_COUNT = 1;
          GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
          GIT_CONFIG_VALUE_0 = "git@github.com:";
        });
      
        nativeBuildInputs = with pkgs; [ vulkan-headers meson ninja pkg-config jq ];
      
        buildInputs = with pkgs; [ vulkan-headers vulkan-loader vulkan-utility-libraries libX11 libXrandr libxcb wayland ];
      
        # Help vulkan-loader find the validation layers
        setupHook = pkgs.writeText "setup-hook" ''
          addToSearchPath XDG_DATA_DIRS @out@/share
        '';
      
        meta = with pkgs.lib; {
          description = "Layers providing Vulkan HDR";
          homepage = "https://github.com/Drakulix/VK_hdr_layer";
          platforms = platforms.linux;
          license = licenses.mit;
        };
      };
    };
  }
  
