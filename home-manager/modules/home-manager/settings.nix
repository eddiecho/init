{lib, ...}: {
  options.settings = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "eddie";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Eddie Cho";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "eunseocho@gmail.com";
    };
  };
}
