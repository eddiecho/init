inputs: let
  lib = inputs.nixpkgs.lib;
in
  lib
  // rec {
    flattenAttrset = attrs: builtins.foldl' lib.mergeAttrs {} (builtins.attrValues attrs);

    filesInDirWithSuffix = dir: suffix:
      lib.pipe (lib.filesystem.listFilesRecursive dir) [
        (builtins.filter (name: lib.hasSuffix suffix name))
      ];

    nixFiles = dir: filesInDirWithSuffix dir ".nix";

    importOverlays = dir: lib.pipe (nixFiles dir) [(map (file: (import file) inputs))];

    overlays =
      [
        inputs.nur.overlays.default
      ]
      ++ (importOverlays ../overlays);

    defaultFilesToAttrset = dir:
      lib.pipe (nixFiles dir) [
        (map (file: {
          name = builtins.baseNameOf (builtins.dirOf file);
          value = import file;
        }))

        (builtins.listToAttrs)
      ];

    supportedSystems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];

    linuxSystems = builtins.filter (lib.hasSuffix "linux") supportedSystems;
    darwinSystems = builtins.filter (lib.hasSuffix "darwin") supportedSystems;

    forSystems = systems: lib.genAttrs systems;
    forAllSystems = lib.genAttrs supportedSystems;

    # { x86_64-linux = { window = { settings = ...; }; }; };
    hosts = forAllSystems (system: defaultFilesToAttrset ../hosts/${system});
    linuxHosts = lib.filterAttrs (name: value: builtins.elem name linuxSystems) hosts;
    darwinHosts = lib.filterAttrs (name: value: builtins.elem name darwinSystems) hosts;

    # { system -> pkgs }
    pkgsBySystem = forAllSystems (
      system:
        import inputs.nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        }
    );

    homeModule = {
      home-manager = {
        sharedModules = nixFiles ../modules/home-manager;
        # use system level nixpkgs instead of home-manager's
        useGlobalPkgs = lib.mkDefault true;
        # install packages to /etc/profiles instead of ~/.nix-profile
        useUserPackages = lib.mkDefault true;
      };
    };

    buildHome = {
      system,
      modules,
      specialArgs,
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsBySystem.${system};
        modules =
          [
            {imports = nixFiles ../modules/home-manager;}
          ]
          ++ modules;
        extraSpecialArgs = {} // specialArgs;
      };

    buildNixos = {
      system,
      modules,
      specialArgs,
    }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        pkgs = pkgsBySystem.${system};
        modules =
          [
            {imports = nixFiles ../modules/nixos;}
            {
              home-manager =
                {
                  extraSpecialArgs = {} // specialArgs;
                }
                // homeModule.home-manager;
            }
          ]
          ++ modules;
      };

    buildDarwin = {
      system,
      modules,
      specialArgs,
    }:
      inputs.darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules =
          [
            {
              imports = nixFiles ../modules/darwin;
              nixpkgs.pkgs = pkgsBySystem.${system};
            }
            {
              home-manager =
                {
                  extraSpecialArgs = {} // specialArgs;
                }
                // homeModule.home-manager;
            }
          ]
          ++ modules;
      };
  }
