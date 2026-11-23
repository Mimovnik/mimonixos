{
  getSystem,
  inputs,
  ...
}: {
  flake.homeModules.homeAgents = {pkgs, ...}: let
    systemConfig = getSystem pkgs.stdenv.hostPlatform.system;
  in {
    home.file = {
      ".codex/AGENTS.md".source = ./human-in-the-loop-mode.md;
      ".agents/skills/review-risks" = {
        source = ./skills/review-risks;
      };
      ".agents/skills/review-quality" = {
        source = ./skills/review-quality;
      };
      ".agents/skills/landscape" = {
        source = ./skills/landscape;
      };
    };

    home.packages = [
      systemConfig.packages.codex
      pkgs.bubblewrap
      pkgs.mcp-nixos
    ];
  };

  perSystem = {pkgs, ...}: {
    packages.codex = inputs.nix-wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.codex;
      addFlag = [
        ["-c" ''mcp_servers.nixos.command="${pkgs.mcp-nixos}/bin/mcp-nixos"'']
        ["-c" ''mcp_servers.linear.url="https://mcp.linear.app/mcp"'']
      ];
    };
  };
}
