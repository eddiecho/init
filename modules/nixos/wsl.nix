{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nixos.wsl;
in {
  options.nixos.wsl = {
    enable = lib.mkEnableOption "Enable WSL";

    windowsUsername = lib.mkOption {
      type = lib.types.str;
    };

    wslconfig = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf (oneOf [str int bool]));
      default = {};
      example = {wsl2.networkingMode = "mirrored";};
      description = ''
        Keys to set in the Windows-side %UserProfile%\.wslconfig.
        Activation changes only these keys and keeps all other keys.
        The changes take effect after `wsl --shutdown`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # NixOS-WSL manages only /etc/wsl.conf. VM-wide settings such as
    # networkingMode are only read from .wslconfig on the Windows side.
    system.activationScripts.wslconfig = lib.mkIf (cfg.wslconfig != {}) (
      let
        file = "/mnt/c/Users/${cfg.windowsUsername}/.wslconfig";
        setKey = section: key: value: let
          v =
            if builtins.isBool value
            then lib.boolToString value
            else toString value;
        in "${lib.getExe pkgs.crudini} --set ${lib.escapeShellArgs [file section key v]}\n";
      in ''
        if [ -d ${lib.escapeShellArg (builtins.dirOf file)} ]; then
          ${lib.concatStrings (lib.flatten (lib.mapAttrsToList (s: lib.mapAttrsToList (setKey s)) cfg.wslconfig))}
        fi
      ''
    );

    wsl = {
      enable = true;
      defaultUser = lib.mkDefault config.settings.username;
      interop.includePath = lib.mkDefault true;
    };

    environment.sessionVariables = {
      WIN_HOME_DIR = "/mnt/c/Users/${config.nixos.wsl.windowsUsername}";
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];
  };
}
