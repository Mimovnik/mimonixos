{pkgs, ...}: {
  home.file.".codex/AGENTS.md".source = ./human-in-the-loop-mode.md;

  # Currently needed in CODEX_HOME/config.toml for Codex to connect:
  # [mcp_servers.nixos]
  # command = "mcp-nixos"
  # type = "stdio"
  home.packages = with pkgs; [
    unstable.codex
    mcp-nixos
  ];
}
