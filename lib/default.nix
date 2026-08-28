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
        (builtins.filter (file: builtins.baseNameOf file == "default.nix"))

        (map (file: {
          name = builtins.baseNameOf (builtins.dirOf file);
          value = import file;
        }))

        (builtins.foldl' (
            acc: {
              name,
              value,
            }:
              if acc ? ${name}
              then throw "defaultFilesToAttrset: duplicate host name \"${name}\" under ${toString dir}"
              else acc // {${name} = value;}
          )
          {})
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

    # Standalone (non-NixOS/non-darwin) home-manager-only hosts, kept in a
    # separate hosts/home/ tree so a name here can never collide with — and
    # get silently overwritten by — a system-managed host of the same name.
    # See hosts/home/README.md. Guarded with pathExists since it's fine for
    # this tree to be empty (or missing a given system) most of the time.
    homeHosts = forAllSystems (
      system: let
        dir = ../hosts/home/${system};
      in
        if builtins.pathExists dir
        then defaultFilesToAttrset dir
        else {}
    );

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

    # Standalone home-manager, unrelated to buildNixos/buildDarwin below —
    # no useGlobalPkgs/useUserPackages, no shared system generation. Only
    # for hosts/home/ hosts; never point this at an already NixOS/darwin-
    # managed host (see hosts/home/README.md).
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
