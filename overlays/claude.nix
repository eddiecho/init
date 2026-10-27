inputs: final: prev:
(inputs.claude-code.overlays.default final prev)
// {
  mcp-nixos = inputs.mcp-nixos.packages.${prev.stdenv.hostPlatform.system}.default;
}
