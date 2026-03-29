{
  globals.mapleader = " ";

  keymaps = [
    # Lsp
    {
      mode = "n";
      key = "K";
      action = "<cmd>Lspsaga hover_doc<CR>";
      options = {
        desc = "Hover documentation";
      };
    }

    {
      mode = "n";
      key = "<leader>a";
      action = "<cmd>Lspsaga code_action<CR>";
      options = {
        desc = "Code action";
      };
    }

    {
      mode = "n";
      key = "<leader>r";
      action = "<cmd>Lspsaga rename<CR>";
      options = {
        desc = "Rename";
      };
    }

    {
      mode = "n";
      key = "<C-n>";
      action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
      options = {
        desc = "Go to next diagnostic";
      };
    }

    {
      mode = "n";
      key = "<C-p>";
      action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
      options = {
        desc = "Go to previous diagnostic";
      };
    }

    {
      mode = "n";
      key = "gd";
      action = "<cmd>Lspsaga finder def<CR>";
      options = {
        desc = "Go to definitions";
      };
    }

    {
      mode = "n";
      key = "gr";
      action = "<cmd>Lspsaga finder ref<CR>";
      options = {
        desc = "Go to references";
      };
    }

    {
      mode = "n";
      key = "gI";
      action = "<cmd>Lspsaga finder imp<CR>";
      options = {
        desc = "Go to implementations";
      };
    }

    # Quickfixlist
    {
      mode = "n";
      key = "<leader>j";
      action = "<cmd>cnext<CR>zz";
      options = {
        desc = "Go to next item from quickfix list";
      };
    }

    {
      mode = "n";
      key = "<leader>k";
      action = "<cmd>cprev<CR>zz";
      options = {
        desc = "Go to previous item from quickfix list";
      };
    }

    # Telescope
    {
      mode = "n";
      key = "<leader>f";
      action = "+Find";
    }

    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options = {
        desc = "Find help";
      };
    }

    {
      mode = "n";
      key = "<leader>fk";
      action = "<cmd>Telescope keymaps<CR>";
      options = {
        desc = "Find keymaps";
      };
    }

    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<CR>";
      options = {
        desc = "Find files";
      };
    }

    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      options = {
        desc = "Find buffers";
      };
    }

    {
      mode = "n";
      key = "<leader>fc";
      action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
      options = {
        desc = "Find in current buffer";
      };
    }

    {
      mode = "n";
      key = "<leader>fw";
      action = "<cmd>Telescope live_grep<CR>";
      options = {
        desc = "Find word in all files";
      };
    }

    {
      mode = "n";
      key = "<leader>fs";
      action = "<cmd>Telescope grep_string<CR>";
      options = {
        desc = "Find string under cursor in all files";
      };
    }

    # Git
    {
      mode = "n";
      key = "<leader>g";
      action = "+Git";
    }

    {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>Telescope git_status<CR>";
      options = {
        desc = "Show git status (with diff preview)";
      };
    }

    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>Telescope git_commits<CR>";
      options = {
        desc = "Show git commits and diff preview";
      };
    }

    # Comments
    {
      mode = "n";
      key = "<leader>/";
      action = "<Esc><cmd>lua require('Comment.api').toggle.linewise.current()<cr>";
      options = {
        desc = "Toggle comment";
      };
    }

    {
      mode = "v";
      key = "<leader>/";
      action = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
      options = {
        desc = "Toggle comment";
      };
    }

    # Utils
    {
      mode = "n";
      key = "<leader>u";
      action = "+Utils";
    }

    {
      mode = "n";
      key = "<leader>uf";
      action = "<cmd>lua require('conform').format()<cr>";
      options = {
        silent = true;
        desc = "Format Buffer";
      };
    }

    {
      mode = "n";
      key = "<leader>ud";
      action = "<cmd>lua require('neogen').generate()<cr>";
      options = {
        desc = "Generate python docstring";
      };
    }

    {
      mode = "n";
      key = "<leader>ug";
      action = "<cmd>Copilot panel<cr>";
      options = {
        desc = "Open copilot panel";
      };
    }

    #BufferLine
    {
      mode = "n";
      key = "<Tab>";
      action = "<cmd>BufferLineCycleNext<cr>";
      options = {
        desc = "Cycle to next buffer";
      };
    }

    {
      mode = "n";
      key = "<S-Tab>";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options = {
        desc = "Cycle to previous buffer";
      };
    }

    # Bufdelete
    {
      mode = "n";
      key = "<leader>x";
      action = "<cmd>Bdelete<cr>";
      options = {
        desc = "Delete current buffer";
      };
    }

    # nvim-tree
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>NvimTreeToggle<cr>";
      options = {
        desc = "Toggle file explorer";
      };
    }

    # Clear highlights
    {
      mode = ["n"];
      key = "<Esc>";
      action = "<cmd>noh<CR>";
      options = {
        desc = "Clear highlights";
      };
    }

    # Delete to void register
    {
      mode = ["n" "v"];
      key = "<leader>D";
      action = "\"_d";
      options = {
        desc = "Delete to void register";
      };
    }

    # Window movement
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        desc = "Switch to window on left";
      };
    }

    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        desc = "Switch to window on right";
      };
    }

    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        desc = "Switch to window down";
      };
    }

    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        desc = "Switch to window up";
      };
    }

    # Disable arrow keys
    {
      mode = ["n" "i"];
      key = "<Up>";
      action = "<Nop>";
      options = {
        silent = true;
        noremap = true;
        desc = "Disable Up arrow key";
      };
    }
    {
      mode = ["n" "i"];
      key = "<Down>";
      action = "<Nop>";
      options = {
        silent = true;
        noremap = true;
        desc = "Disable Down arrow key";
      };
    }
    {
      mode = ["n" "i"];
      key = "<Right>";
      action = "<Nop>";
      options = {
        silent = true;
        noremap = true;
        desc = "Disable Right arrow key";
      };
    }
    {
      mode = ["n" "i"];
      key = "<Left>";
      action = "<Nop>";
      options = {
        silent = true;
        noremap = true;
        desc = "Disable Left arrow key";
      };
    }
  ];
}
