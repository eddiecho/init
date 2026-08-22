{lib, ...}: {
  options.settings = {
    username = lib.mkOption {
      type = lib.types.str;
    };
    fullName = lib.mkOption {
      type = lib.types.str;
    };
    email = lib.mkOption {
      type = lib.types.str;
    };
    anonName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
    };
    anonEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
    };
  };
}
