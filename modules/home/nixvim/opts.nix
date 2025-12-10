{
  opts = {
    number = true;
    relativenumber = true;

    # Set clipboard to sytem one
    clipboard = "unnamedplus";

    # Set tabs to 2 spaces
    tabstop = 2;
    softtabstop = 2;
    showtabline = 2;
    expandtab = true;

    # Enable auto indenting and set it to spaces
    smartindent = true;
    shiftwidth = 2;

    # Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
    breakindent = true;

    # Enable text wrap
    wrap = true;

    # Enable mouse mode
    mouse = "a"; # Mouse

    # Configure how new splits should be opened
    splitright = true;
    splitbelow = true;

    # Enable ignorecase + smartcase for better searching
    ignorecase = true;
    smartcase = true; # Don't ignore case with capitals
    grepprg = "rg --vimgrep";
    grepformat = "%f:%l:%c:%m";

    # Decrease updatetime
    updatetime = 250;

    # Displays which-key popup sooner
    timeoutlen = 0;

    # Show which line your cursor is on
    cursorline = true;

    # Minimal number of screen lines to keep above and below the cursor.
    scrolloff = 10;

    # Keep signcolumn on by default
    signcolumn = "yes";

    # Set completeopt to have a better completion experience
    completeopt = ["menuone" "noselect" "noinsert"]; # mostly just for cmp

    # Enable persistent undo history
    swapfile = false;
    backup = false;
    undofile = true;
  };
}
