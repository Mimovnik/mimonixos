{lib, ...}: {
  options.mimo.webapps = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        title = lib.mkOption {
          type = lib.types.str;
          description = "Display title of the web application";
        };
        exec = lib.mkOption {
          type = lib.types.str;
          description = "Command to execute the web application";
        };
      };
    });
    default = {};
    description = "Web applications configuration";
  };

  config.mimo.webapps = let
    browser = "brave --password-store=gnome";
  in {
    chatgpt = {
      title = "ChatGPT";
      exec = "${browser} --app=https://chat.openai.com";
    };
    github = {
      title = "GitHub";
      exec = "${browser} --app=https://github.com";
    };
    youtube-music = {
      title = "YouTube Music";
      exec = "${browser} --app=https://music.youtube.com";
    };
    youtube = {
      title = "YouTube";
      exec = "${browser} --app=https://youtube.com";
    };
    protonmail = {
      title = "ProtonMail";
      exec = "${browser} --app=https://mail.proton.me";
    };
    enauczanie = {
      title = "eNauczanie";
      exec = "${browser} --app=https://enauczanie.pg.edu.pl/2025/my/";
    };
    nextcloud-files = {
      title = "Nextcloud Files";
      exec = "${browser} --app=https://kwidzinski.net.pl/apps/files";
    };
    nextcloud-deck = {
      title = "Nextcloud Deck/Board";
      exec = "${browser} --app=https://kwidzinski.net.pl/apps/deck/board/4";
    };
    nextcloud-calendar = {
      title = "Nextcloud Calendar";
      exec = "${browser} --app=https://kwidzinski.net.pl/apps/calendar";
    };
  };
}
