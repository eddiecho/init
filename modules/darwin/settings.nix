{lib, ...}: {
  options.settings = {
    username = lib.mkOption {
      type = lib.types.str;
    };
    fullName = lib.mkOption {
      type = lib.types.str;
    };
  };
}
