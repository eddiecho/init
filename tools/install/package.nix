{pkgs, ...}:
pkgs.writeShellApplication {
  name = "install";
  runtimeInputs = with pkgs; [nixos-install-tools jq util-linux];
  text = ''
    usage() {
      cat >&2 <<EOF
    usage: install <host> [flake-uri] [disk-device]

      host         a hosts/x86_64-linux/<host> directory name
      flake-uri    default: github:eddiecho/init
                   The host files must be visible at this URI.
                   For an unpushed checkout, use path:/path/to/init.
      disk-device  the disk to ERASE and install onto, e.g. /dev/nvme0n1
                   Required if the host has a disko config.

    Before you run this for a new host, generate its hardware config with
      nixos-generate-config --no-filesystems --show-hardware-config
    The --no-filesystems flag prevents a conflict with the disko mounts.

    Full steps: tools/install/README.md
    EOF
      exit 1
    }

    HOST=''${1:-}
    [[ -n $HOST ]] || usage
    FLAKE_URI=''${2:-github:eddiecho/init}
    DISK_DEVICE=''${3:-}
    NIX=(nix --extra-experimental-features "nix-command flakes")

    mapfile -t DISKS < <(
      "''${NIX[@]}" eval --json \
        "$FLAKE_URI#nixosConfigurations.$HOST.config.disko.devices.disk" \
        --apply builtins.attrNames | jq -r '.[]'
    )

    if [[ ''${#DISKS[@]} -eq 0 ]]; then
      echo "$HOST has no disko config. Using the partitions mounted at /mnt." >&2
      if ! mountpoint -q /mnt; then
        echo "error: /mnt is not mounted. Partition and mount the disk first." >&2
        exit 1
      fi
      [[ $EUID -eq 0 ]] || { echo "error: run as root" >&2; exit 1; }
      nixos-install --flake "$FLAKE_URI#$HOST"
      exit 0
    fi

    if [[ ''${#DISKS[@]} -gt 1 ]]; then
      echo "error: $HOST has more than one disko disk: ''${DISKS[*]}" >&2
      echo "Run disko-install directly with one --disk <name> <device> per disk." >&2
      exit 1
    fi

    if [[ -z $DISK_DEVICE ]]; then
      lsblk -o NAME,SIZE,TYPE,MODEL,MOUNTPOINTS >&2
      echo >&2
      echo "error: give the disk device as the third argument." >&2
      usage
    fi

    [[ $EUID -eq 0 ]] || { echo "error: run as root" >&2; exit 1; }

    lsblk -o NAME,SIZE,TYPE,MODEL,MOUNTPOINTS "$DISK_DEVICE"
    echo
    echo "This ERASES ALL DATA on $DISK_DEVICE."
    read -rp "Type the device path again to continue: " CONFIRM
    if [[ $CONFIRM != "$DISK_DEVICE" ]]; then
      echo "error: confirmation does not match. Nothing was changed." >&2
      exit 1
    fi

    INSTALL_ARGS=(
      --flake "$FLAKE_URI#$HOST"
      --disk "''${DISKS[0]}" "$DISK_DEVICE"
      --write-efi-boot-entries
    )

    # disko-install unmounts the target when it exits.
    # Copy a local checkout during the install, or the ISO RAM is its only copy.
    if [[ $FLAKE_URI == path:* ]]; then
      USERNAME=$("''${NIX[@]}" eval --raw "$FLAKE_URI#nixosConfigurations.$HOST.config.settings.username")
      CHECKOUT_DEST="/home/$USERNAME/init"
      INSTALL_ARGS+=(--extra-files "''${FLAKE_URI#path:}" "$CHECKOUT_DEST")
    fi

    # --inputs-from pins disko-install to the disko version in the flake lock.
    "''${NIX[@]}" run --inputs-from "$FLAKE_URI" disko#disko-install -- "''${INSTALL_ARGS[@]}"

    if [[ -n ''${CHECKOUT_DEST:-} ]]; then
      echo "Copied the checkout to $CHECKOUT_DEST. Commit the new host from there."
    fi
  '';
}
