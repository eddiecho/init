{ lib, ... }:

{
  options.settings = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "eddie";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Eddie Cho";
    };
  };
}
