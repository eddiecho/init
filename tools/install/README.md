# install

Installs a NixOS host from this flake onto a fresh machine, from the NixOS installer ISO.
`bootstrap.sh` is a different tool, for machines that do not run NixOS.

## New host

You can write `default.nix` and `disko.nix` on any machine before the install.
Only the disk device and `hardware-configuration.nix` need the target machine.

1. Boot the NixOS installer ISO.

2. Clone this repo:

   ```sh
   nix shell nixpkgs#git          # if the ISO has no git
   git clone https://github.com/eddiecho/init && cd init
   ```

3. Create the host directory:

   ```sh
   mkdir -p hosts/x86_64-linux/<name>
   ```

   - `default.nix`: copy `hosts/x86_64-linux/framework/default.nix`.
     Change `networking.hostName` and the `nixos.*` toggles.
     Keep `./disko.nix` in `imports`.
   - `disko.nix`: copy `hosts/x86_64-linux/framework/disko.nix`, or an example from
     https://github.com/nix-community/disko/tree/master/example.
     If you copy the framework file, delete the `label` lines and the header comment.
     They match the partitions on the framework disk only.
     Set the swap size. For hibernation, swap must be at least the size of RAM.

4. Generate the hardware config:

   ```sh
   nixos-generate-config --no-filesystems --show-hardware-config \
     > hosts/x86_64-linux/<name>/hardware-configuration.nix
   ```

   `--no-filesystems` is necessary. Without it, the generated mounts conflict with the disko mounts.

5. Check the config. This does not touch a disk:

   ```sh
   nix --extra-experimental-features 'nix-command flakes' \
     build "path:$PWD#nixosConfigurations.<name>.config.system.build.diskoScript"
   ```

6. Find the target disk with `lsblk`, then install:

   ```sh
   sudo nix --extra-experimental-features 'nix-command flakes' \
     run "path:$PWD#tools.x86_64-linux.install" -- <name> "path:$PWD" /dev/<disk>
   ```

   Use `path:$PWD`, not the default `github:eddiecho/init`.
   The new host files are only in this clone, and git does not track them yet.
   A `github:` or `git+file:` flake ref does not see them.

   The tool asks you to type the device path again. Then it erases the disk.

7. Reboot. With a `path:` flake ref, the tool copies the clone to `/home/<username>/init` on the new disk.
   The ISO keeps the clone in RAM only, so this is the only copy that remains.
   Commit the new host from there.
   The copy keeps the file owner of the ISO user (uid 1000).
   If your user has a different uid, run `sudo chown -R <username>: ~/init`.

## Existing host

For a host that is already in the repo on GitHub, you can skip the clone:

```sh
sudo nix --extra-experimental-features 'nix-command flakes' \
  run github:eddiecho/init#tools.x86_64-linux.install -- <name> github:eddiecho/init /dev/<disk>
```

A host with no `disko.nix` falls back to `nixos-install`.
You must partition the disk and mount it at `/mnt` before you run the tool.
