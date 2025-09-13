rec {
  default = empty;

  empty = {
    path = ./empty;
    description = "Empty development shell template";
  };

  unfree = {
    path = ./unfree;
    description = "Unfree development shell template";
  };

  c = {
    path = ./c;
    description = "C development shell template";
  };

  kernel = {
    path = ./kernel;
    description = "Out-of-tree Linux Kernel Module development shell template";
  };

  python = {
    path = ./python;
    description = "Python development shell template";
  };

  rust = {
    path = ./rust;
    description = "Rust development shell template";
  };

  flutter = {
    path = ./flutter;
    description = "Flutter development shell template";
  };

  unity = {
    path = ./unity;
    description = "Unity development shell template with .NET 6 support";
  };
}
