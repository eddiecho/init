{
  config,
  pkgs,
  lib,
  root,
  ...
}: let
  cfg = config.modules.apps.ssh;

  wslHosts = builtins.attrNames (
    lib.filterAttrs (_: host: host.config.nixos.wsl.enable or false) root.nixosConfigurations
  );

  # A WSL host in mirrored networking mode has no tailnet node of its own.
  # It shares the node of its Windows machine. This script finds that node at
  # connect time, so the config does not contain the Windows machine name.
  tailscaleWindowsProxy = pkgs.writeShellApplication {
    name = "tailscale-windows-proxy";
    runtimeInputs = with pkgs; [tailscale jq];
    text = ''
      ip=$(tailscale status --json | jq -er '
        [.Peer[] | select(.OS == "windows" and .Online)]
        | if length == 1 then .[0].TailscaleIPs[0]
          else error("expected 1 online windows peer, found \(length)") end
      ')
      exec tailscale nc "$ip" "$1"
    '';
  };
in {
  options.modules.apps.ssh = {
    enable = lib.mkEnableOption "Enable ssh";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = lib.genAttrs wslHosts (_: {
        user = config.settings.username;
        proxyCommand = "${lib.getExe tailscaleWindowsProxy} %p";
      });
    };
  };
}
