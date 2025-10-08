{
  xdg.desktopEntries = let
    browser = "brave --password-store=gnome";
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
      name = "ChatGPT";
      comment = "AI-powered chat assistant";
      exec = "${browser} --app=https://chat.openai.com";
      icon = "chatgpt";
      categories = ["X-Ai" "Utility" "Education"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    github = {
      name = "GitHub";
      comment = "Code hosting platform";
      exec = "${browser} --app=https://github.com";
      icon = "github";
      categories = ["Development" "Network"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    youtube-music = {
      name = "YouTube Music";
      comment = "Music streaming service";
      exec = "${browser} --app=https://music.youtube.com";
      icon = "youtube-music";
      categories = ["Audio" "Player" "Music"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    youtube = {
      name = "YouTube";
      comment = "Video streaming platform";
      exec = "${browser} --app=https://youtube.com";
      icon = "youtube";
      categories = ["Audio" "Video" "Player" "X-Entertainment"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    protonmail = {
      name = "ProtonMail";
      comment = "Secure email service";
      exec = "${browser} --app=https://mail.proton.me";
      icon = "protonmail";
      categories = ["Network" "Email" "Office" "X-Communication"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    enauczanie = {
      name = "eNauczanie";
      comment = "Educational platform";
      exec = "${browser} --app=https://enauczanie.pg.edu.pl/2025/my/";
      icon = "enauczanie";
      categories = ["Education"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    nextcloud-files = {
      name = "Nextcloud Files";
      comment = "Files on Nextcloud";
      exec = "${browser} --app=https://kwidzinski.net.pl/apps/files";
      icon = "nextcloud";
      categories = ["Network" "FileManager" "FileTransfer"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    nextcloud-tasks = {
      name = "Nextcloud Tasks";
      comment = "Tasks on Nextcloud";
      exec = "${browser} --app=https://kwidzinski.net.pl/apps/tasks";
      icon = "nextcloud";
      categories = ["Network" "X-Productivity"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };

    nextcloud-calendar = {
      name = "Nextcloud Calendar";
      comment = "Calendar on Nextcloud";
      exec = "${browser} --app=https://kwidzinski.net.pl/apps/calendar";
      icon = "nextcloud";
      categories = ["Network" "X-Productivity"];
      mimeType = ["text/html" "application/xhtml+xml"];
    };
  };
}
