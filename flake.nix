{
  inputs.minegrub-theme.url = "github:Lxtharia/minegrub-theme";

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.HOSTNAME = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        inputs.minegrub.nixosModules.default
      ];
    };
  };
}