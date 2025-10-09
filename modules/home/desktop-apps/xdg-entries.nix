{config, ...}: {
  xdg.desktopEntries = let
    webapps = config.mimo.webapps;
  in {
    # name = {
    #   name = "Display Name";
    #   comment = "Description";
    #   exec = "${browser} --app=https://url";
    #   icon = "icon-name";
    #   categories = ["Category1" "Category2" "X-CustomCategory"];
    #   mimeType = ["text/html" "application/xhtml+xml"];
    # };

    chatgpt = {
      name = webapps.chatgpt.title;
      comment = "AI-powered chat assistant";
      exec = webapps.chatgpt.exec;
      icon = "chatgpt";
      categories = ["X-Ai" "Utility" "Education"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    github = {
      name = webapps.github.title;
      comment = "Code hosting platform";
      exec = webapps.github.exec;
      icon = "github";
      categories = ["Development" "Network"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    youtube-music = {
      name = webapps.youtube-music.title;
      comment = "Music streaming service";
      exec = webapps.youtube-music.exec;
      icon = "youtube-music";
      categories = ["Audio" "Player" "Music"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    youtube = {
      name = webapps.youtube.title;
      comment = "Video streaming platform";
      exec = webapps.youtube.exec;
      icon = "youtube";
      categories = ["Audio" "Video" "Player" "X-Entertainment"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    protonmail = {
      name = webapps.protonmail.title;
      comment = "Secure email service";
      exec = webapps.protonmail.exec;
      icon = "protonmail";
      categories = ["Network" "Email" "Office" "X-Communication"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    enauczanie = {
      name = webapps.enauczanie.title;
      comment = "Educational platform";
      exec = webapps.enauczanie.exec;
      icon = "enauczanie";
      categories = ["Education"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    nextcloud-files = {
      name = webapps.nextcloud-files.title;
      comment = "Files on Nextcloud";
      exec = webapps.nextcloud-files.exec;
      icon = "nextcloud";
      categories = ["Network" "FileManager" "FileTransfer"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    nextcloud-deck = {
      name = webapps.nextcloud-deck.title;
      comment = "Kanban board on Nextcloud";
      exec = webapps.nextcloud-deck.exec;
      icon = "nextcloud";
      categories = ["Network" "X-Productivity"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    nextcloud-calendar = {
      name = webapps.nextcloud-calendar.title;
      comment = "Calendar on Nextcloud";
      exec = webapps.nextcloud-calendar.exec;
      icon = "nextcloud";
      categories = ["Network" "X-Productivity"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };
  };
}
