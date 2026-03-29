{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "bufdelete";
      src = pkgs.fetchFromGitHub {
        owner = "famiu";
        repo = "bufdelete.nvim";
        rev = "f6bcea78afb3060b198125256f897040538bcb81";
        hash = "sha256-ljUNfmpImtxFCS19HC9kFlaLlqaPDltKtnx1+/6Y33U=";
      };
    })
  ];
}
