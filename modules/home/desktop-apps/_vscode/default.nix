{pkgs, ...}: {
  # TODO: Declarative vscode
  home.packages = with pkgs; [
    unstable.vscode-fhs
  ];
}
