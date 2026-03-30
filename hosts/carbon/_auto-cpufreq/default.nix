{
  services.power-profiles-daemon.enable = false;

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        energy_performance_preference = "power";
        energy_perf_bias = "power";
        platform_profile = "quiet";
        scaling_min_freq = 800000;
        scaling_max_freq = 1400000;
        turbo = "never";
      };

      charger = {
        governor = "performance";
        energy_performance_preference = "performance";
        energy_perf_bias = "performance";
        platform_profile = "performance";
        scaling_min_freq = 800000;
        scaling_max_freq = 2600000;
        turbo = "always";
      };
    };
  };
}
