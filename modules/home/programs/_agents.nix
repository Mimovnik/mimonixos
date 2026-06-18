{pkgs, ...}: {
  # Currently needed in CODEX_HOME/config.toml for Codex to connect:
  # [mcp_servers.nixos]
  # command = "mcp-nixos"
  # type = "stdio"
  home.packages = with pkgs; [
    codex
    mcp-nixos
  ];
}
