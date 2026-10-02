# The labels match the partitions already on this disk.
# Do not change them unless the disk is formatted again: the
# generated mounts use /dev/disk/by-partlabel/<label>.
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          label = "ESP";
          priority = 1;
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            extraArgs = ["-n" "boot"];
            mountpoint = "/boot";
            mountOptions = ["fmask=0077" "dmask=0077"];
          };
        };
        root = {
          label = "root";
          priority = 2;
          end = "-16G";
          content = {
            type = "filesystem";
            format = "ext4";
            extraArgs = ["-L" "root"];
            mountpoint = "/";
          };
        };
        swap = {
          label = "swap";
          size = "100%";
          content = {
            type = "swap";
            extraArgs = ["-L" "swap"];
          };
        };
      };
    };
  };
}
