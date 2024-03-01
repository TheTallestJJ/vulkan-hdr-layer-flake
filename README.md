# vulkan-hdr-layer-flake

All credit goes to [zamundaaa/VK_hdr_layer](https://github.com/Zamundaaa/VK_hdr_layer) for the original implementation, and the people [in this issue](https://github.com/nix-community/kde2nix/issues/20) for the nix package description. This simply repackages it as a flake for easy use.

## How to use

I really struggled finding some reliable sources on how to import the flake, this is what I found works:

```flake.nix
{
  inputs = { # v Add this input
    hdrvulkan.url = "github:TheTallestJJ/vulkan-hdr-layer-flake/8a003118967530c6da2eba76aa1d89a7161cf9f3";
  };

  outputs = { self, nixpkgs, ... }@inputs: {

    nixosConfigurations = {
      "My Hostname" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # <-- Add this line
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
```

```configuration.nix
{ config, pkgs, inputs, ... }: # <-- add inputs at the top of file

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
...

... #v set these two settings to use the new plasma 6, and to enable gamescope
  services.xserver.desktopManager.plasma6.enable = true;
  programs.steam.gamescopeSession.enable = true;
...

...
  environment.systemPackages = [
    inputs.hdrvulkan.packages.${pkgs.system}.default #<-- Add this to your system packages
  ];
}
```
