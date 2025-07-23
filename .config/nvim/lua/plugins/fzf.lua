return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { 
      "nvim-tree/nvim-web-devicons",
      { "junegunn/fzf", build = "./install --bin" },
    },
    cmd = "FzfLua",
    keys = {
      -- File operations
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find Buffers" },
      { "<leader>fq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
      { "<leader>fl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
      
      -- Search operations
      { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Grep Word Under Cursor" },
      { "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", desc = "Grep WORD Under Cursor" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
      { "<leader>fG", "<cmd>FzfLua live_grep_glob<cr>", desc = "Live Grep with Glob" },
      { "<leader>fs", "<cmd>FzfLua grep_string<cr>", desc = "Grep String" },
      { "<leader>fv", "<cmd>FzfLua grep_visual<cr>", mode = "v", desc = "Grep Visual Selection" },
      { "<leader>f/", "<cmd>FzfLua search_history<cr>", desc = "Search History" },
      
      -- Git operations  
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Git Commits" },
      { "<leader>gC", "<cmd>FzfLua git_bcommits<cr>", desc = "Git Buffer Commits" },
      { "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "Git Branches" },
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git Status" },
      { "<leader>gS", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash" },
      { "<leader>gt", "<cmd>FzfLua git_tags<cr>", desc = "Git Tags" },
      
      -- LSP operations
      { "<leader>lr", "<cmd>FzfLua lsp_references<cr>", desc = "LSP References" },
      { "<leader>ld", "<cmd>FzfLua lsp_definitions<cr>", desc = "LSP Definitions" },
      { "<leader>lD", "<cmd>FzfLua lsp_declarations<cr>", desc = "LSP Declarations" },
      { "<leader>lt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "LSP Type Definitions" },
      { "<leader>li", "<cmd>FzfLua lsp_implementations<cr>", desc = "LSP Implementations" },
      { "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>lS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>lw", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Live Workspace Symbols" },
      { "<leader>le", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
      { "<leader>lE", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
      { "<leader>la", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Code Actions" },
      { "<leader>lf", "<cmd>FzfLua lsp_finder<cr>", desc = "LSP Finder" },
      
      -- Vim operations
      { "<leader>vh", "<cmd>FzfLua help_tags<cr>", desc = "Help Tags" },
      { "<leader>vm", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
      { "<leader>vk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
      { "<leader>vc", "<cmd>FzfLua commands<cr>", desc = "Commands" },
      { "<leader>vC", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      { "<leader>vo", "<cmd>FzfLua colorschemes<cr>", desc = "Colorschemes" },
      { "<leader>va", "<cmd>FzfLua autocmds<cr>", desc = "Autocommands" },
      { "<leader>vH", "<cmd>FzfLua highlights<cr>", desc = "Highlights" },
      { "<leader>vj", "<cmd>FzfLua jumps<cr>", desc = "Jumps" },
      { "<leader>vr", "<cmd>FzfLua registers<cr>", desc = "Registers" },
      { "<leader>vt", "<cmd>FzfLua tabs<cr>", desc = "Tabs" },
      { "<leader>vm", "<cmd>FzfLua marks<cr>", desc = "Marks" },
      { "<leader>vq", "<cmd>FzfLua changes<cr>", desc = "Changes" },
      
      -- Tags and more
      { "<leader>tt", "<cmd>FzfLua tags<cr>", desc = "Tags" },
      { "<leader>tg", "<cmd>FzfLua tags_grep<cr>", desc = "Tags Grep" },
      { "<leader>tG", "<cmd>FzfLua tags_grep_cword<cr>", desc = "Tags Grep Word" },
      { "<leader>tl", "<cmd>FzfLua tags_live_grep<cr>", desc = "Tags Live Grep" },
      
      -- Telescope-like shortcuts (optional alternative bindings)
      { "<C-p>", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      { "<C-f>", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
      { "<C-b>", "<cmd>FzfLua buffers<cr>", desc = "Find Buffers" },
      
      -- Resume last search
      { "<leader>f;", "<cmd>FzfLua resume<cr>", desc = "Resume Last Search" },
      
      -- Spell suggestions
      { "z=", "<cmd>FzfLua spell_suggest<cr>", desc = "Spell Suggestions" },
    },
    config = function()
      local fzf = require("fzf-lua")
      
      fzf.setup({
        -- Global configuration
        global_resume = true,
        global_resume_query = true,
        
        winopts = {
          height = 0.85,
          width = 0.80,
          row = 0.35,
          col = 0.50,
          border = "rounded",
          preview = {
            default = "bat",
            border = "border",
            wrap = "nowrap",
            hidden = "nohidden",
            vertical = "down:45%",
            horizontal = "right:50%",
            layout = "flex",
            flip_columns = 120,
            scrollbar = "float",
          },
          fullscreen = false,
          backdrop = 60,
        },
        
        keymap = {
          builtin = {
            ["<F1>"] = "toggle-help",
            ["<F2>"] = "toggle-fullscreen",
            ["<F3>"] = "toggle-preview-wrap",
            ["<F4>"] = "toggle-preview",
            ["<F5>"] = "toggle-preview-ccw",
            ["<F6>"] = "toggle-preview-cw",
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
            ["<S-left>"] = "preview-page-reset",
          },
          fzf = {
            ["ctrl-z"] = "abort",
            ["ctrl-u"] = "unix-line-discard",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["alt-a"] = "select-all",
            ["alt-d"] = "deselect-all",
          },
        },
        
        previewers = {
          cat = {
            cmd = "cat",
            args = "--number",
          },
          bat = {
            cmd = "bat",
            args = "--style=numbers,changes --color always",
            theme = "Coldark-Dark",
          },
          head = {
            cmd = "head",
            args = nil,
          },
          git_diff = {
            cmd_deleted = "git show HEAD:./%s",
            cmd_modified = "git diff HEAD %s",
            cmd_untracked = "git diff --no-index /dev/null %s",
            pager = "delta --width=$FZF_PREVIEW_COLUMNS",
          },
        },
        
        files = {
          prompt = "Files❯ ",
          multiprocess = true,
          git_icons = true,
          file_icons = true,
          color_icons = true,
          find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
          rg_opts = "--color=never --files --hidden --follow -g '!.git'",
          fd_opts = "--color=never --type f --hidden --follow --exclude .git",
        },
        
        git = {
          status = {
            cmd = "git status -s",
            preview = "git diff HEAD -- {-1}",
            actions = {
              ["right"] = { fzf.actions.git_unstage, fzf.actions.resume },
              ["left"] = { fzf.actions.git_stage, fzf.actions.resume },
            },
          },
          commits = {
            prompt = "Commits❯ ",
            cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
            preview = "git show --pretty='%Cred%H%n%Cblue%an <%ae>%n%C(yellow)%cD%n%Cgreen%s' --color {1}",
            actions = {
              ["default"] = fzf.actions.git_checkout,
            },
          },
        },
        
        grep = {
          prompt = "Rg❯ ",
          input_prompt = "Grep For❯ ",
          multiprocess = true,
          git_icons = true,
          file_icons = true,
          color_icons = true,
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
          grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
        },
        
        lsp = {
          prompt_postfix = "❯ ",
          cwd_only = false,
          async_or_timeout = 5000,
          file_icons = true,
          git_icons = false,
          lsp_icons = true,
          severity = "hint",
          icons = {
            ["Error"] = { icon = "", color = "red" },
            ["Warning"] = { icon = "", color = "yellow" },
            ["Information"] = { icon = "", color = "blue" },
            ["Hint"] = { icon = "", color = "magenta" },
          },
        },
      })
      
      -- Register with which-key if available
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.register({
          ["<leader>f"] = { name = "+find" },
          ["<leader>g"] = { name = "+git" },
          ["<leader>l"] = { name = "+lsp" },
          ["<leader>v"] = { name = "+vim" },
          ["<leader>t"] = { name = "+tags" },
        })
      end
    end,
  },
}
