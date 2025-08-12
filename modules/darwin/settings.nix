{lib, ...}: {
  options.settings = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "Eddie.Cho";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Eddie Cho";
    };
  };
}
