rec {
  default = empty;

  empty = {
    path = ./empty;
    description = "Empty development shell template";
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
}
