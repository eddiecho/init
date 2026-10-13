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
        Activation deletes a key that an earlier activation set and that
        this option no longer contains.
        The changes take effect after `wsl --shutdown`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # NixOS-WSL manages only /etc/wsl.conf. VM-wide settings such as
    # networkingMode are only read from .wslconfig on the Windows side.
    system.activationScripts.wslconfig = let
      crudini = lib.getExe pkgs.crudini;
      file = lib.escapeShellArg "/mnt/c/Users/${cfg.windowsUsername}/.wslconfig";
      # Records the keys that the last activation set, one "section key" per line.
      state = "/var/lib/nixos-wslconfig-keys";
      entries = lib.flatten (lib.mapAttrsToList (section: lib.mapAttrsToList (key: value: {
          inherit section key;
          value =
            if builtins.isBool value
            then lib.boolToString value
            else toString value;
        }))
        cfg.wslconfig);
      id = e: "${e.section} ${e.key}";
    in ''
      if [ -d "$(dirname ${file})" ]; then
        declare -A keep=(${lib.concatMapStrings (e: "[${lib.escapeShellArg (id e)}]=1 ") entries})
        if [ -f ${state} ] && [ -f ${file} ]; then
          while read -r section key; do
            [ -n "$section" ] || continue
            if [ -z "''${keep["$section $key"]-}" ]; then
              ${crudini} --del ${file} "$section" "$key"
            fi
          done < ${state}
        fi
        ${lib.concatMapStrings (e: "${crudini} --set ${file} ${lib.escapeShellArgs [e.section e.key e.value]}\n") entries}
        printf '%s\n' ${lib.escapeShellArgs (map id entries)} > ${state}
      fi
    '';

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
