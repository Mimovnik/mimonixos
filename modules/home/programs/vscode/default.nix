{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mimonix.programs.vscode;
in {
  options.mimonix.programs.vscode = {
    enable = mkEnableOption "Visual Studio Code editor";
  };

  config = mkIf cfg.enable {
    # TODO: Declarative vscode
    home.packages = with pkgs; [
      unstable.vscode-fhs
    ];
  };
}
