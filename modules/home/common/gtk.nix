{pkgs, ...}: {
  home.sessionVariables.GTK_THEME = "Materia-dark";

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };

    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };

    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
  };
}
