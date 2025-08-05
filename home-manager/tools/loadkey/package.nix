{pkgs, ...}:
pkgs.writeShellScriptBin "loadkey" ''
  read -p "Enter the seed phrase for your SSH key... " seed
  echo $seed
  mkdir -p ~/.ssh/
  ${pkgs.melt}/bin/melt restore --seed "''${seed}" ~/.ssh/id_ed25519asdffasdfsdaasdf
  printf "\n\nContinuing activation.\n\n"
''
