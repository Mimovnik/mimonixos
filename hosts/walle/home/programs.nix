{pkgs, ...}: {
  home.packages = with pkgs; [
    auto-cpufreq
  ];
}
