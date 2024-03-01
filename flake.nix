{
  description = "Vulkan HDR Layer Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, ... }: {
    packages = {
      vulkan-hdr-layer = nixpkgs.legacyPackages.${nixpkgs.system or "x86_64-linux"}.vulkan-hdr-layer;
    };
  };
}

