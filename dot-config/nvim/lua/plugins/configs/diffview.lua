return {
	"sindrets/diffview.nvim",
	command = "DiffviewOpen",
	cond = "is_git_root",
	keys = {
		{
			"<leader>gd",
			function()
				require("utils").toggle_diffview("DiffviewOpen")
			end,
			desc = "Diff Index",
		},
		{
			"<leader>gD",
			function()
				require("utils").toggle_diffview("DiffviewOpen master..HEAD")
			end,
			desc = "Diff master",
		},
		{
			"<leader>gf",
			function()
				require("utils").toggle_diffview("DiffviewFileHistory %")
			end,
			desc = "Open diffs for current File",
		},
  },
  config = function()
	  local actions = require("diffview.actions")
    require("diffview").setup({
      keymaps = {
        disable_defaults = false, -- Disable the default keymaps
        view = {
          -- The `view` bindings are active in the diff buffers, only when the current
          -- tabpage is a Diffview.
          { "n", "<tab>",       actions.select_next_entry,              { desc = "Open the diff for the next file" } },
          { "n", "<s-tab>",     actions.select_prev_entry,              { desc = "Open the diff for the previous file" } },
          { "n", "[F",          actions.select_first_entry,             { desc = "Open the diff for the first file" } },
          { "n", "]F",          actions.select_last_entry,              { desc = "Open the diff for the last file" } },
          { "n", "gf",          actions.goto_file_edit,                 { desc = "Open the file in the previous tabpage" } },
          { "n", "<C-w><C-f>",  actions.goto_file_split,                { desc = "Open the file in a new split" } },
          { "n", "<C-w>gf",     actions.goto_file_tab,                  { desc = "Open the file in a new tabpage" } },
          { "n", "<leader>e",   actions.focus_files,                    { desc = "Bring focus to the file panel" } },
          { "n", "<leader>b",   actions.toggle_files,                   { desc = "Toggle the file panel." } },
          { "n", "g<C-x>",      actions.cycle_layout,                   { desc = "Cycle through available layouts." } },
          { "n", "[x",          actions.prev_conflict,                  { desc = "In the merge-tool: jump to the previous conflict" } },
          { "n", "]x",          actions.next_conflict,                  { desc = "In the merge-tool: jump to the next conflict" } },
          { "n", "<leader>co",  actions.conflict_choose("ours"),        { desc = "Choose the OURS version of a conflict" } },
          { "n", "<leader>ct",  actions.conflict_choose("theirs"),      { desc = "Choose the THEIRS version of a conflict" } },
          { "n", "<leader>cb",  actions.conflict_choose("base"),        { desc = "Choose the BASE version of a conflict" } },
          { "n", "<leader>ca",  actions.conflict_choose("all"),         { desc = "Choose all the versions of a conflict" } },
          { "n", "dx",          actions.conflict_choose("none"),        { desc = "Delete the conflict region" } },
          { "n", "<leader>cO",  actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
          { "n", "<leader>cT",  actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
          { "n", "<leader>cB",  actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
          { "n", "<leader>cA",  actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
          { "n", "dX",          actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
        },
        file_panel = {
          { "n", "j",              actions.next_entry,                     { desc = "Bring the cursor to the next file entry" } },
          { "n", "<down>",         actions.next_entry,                     { desc = "Bring the cursor to the next file entry" } },
          { "n", "k",              actions.prev_entry,                     { desc = "Bring the cursor to the previous file entry" } },
          { "n", "<up>",           actions.prev_entry,                     { desc = "Bring the cursor to the previous file entry" } },
          { "n", "<cr>",           actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
          { "n", "o",              actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
          { "n", "l",              actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
          { "n", "<2-LeftMouse>",  actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
          { "n", "-",              actions.toggle_stage_entry,             { desc = "Stage / unstage the selected entry" } },
          { "n", "s",              actions.toggle_stage_entry,             { desc = "Stage / unstage the selected entry" } },
          { "n", "zo",             actions.open_fold,                      { desc = "Expand fold" } },
          { "n", "h",              actions.close_fold,                     { desc = "Collapse fold" } },
          { "n", "zc",             actions.close_fold,                     { desc = "Collapse fold" } },
          { "n", "za",             actions.toggle_fold,                    { desc = "Toggle fold" } },
          { "n", "zR",             actions.open_all_folds,                 { desc = "Expand all folds" } },
          { "n", "zM",             actions.close_all_folds,                { desc = "Collapse all folds" } },
          { "n", "<c-b>",          actions.scroll_view(-0.25),             { desc = "Scroll the view up" } },
          { "n", "<c-f>",          actions.scroll_view(0.25),              { desc = "Scroll the view down" } },
          { "n", "<tab>",          actions.select_next_entry,              { desc = "Open the diff for the next file" } },
          { "n", "<s-tab>",        actions.select_prev_entry,              { desc = "Open the diff for the previous file" } },
          { "n", "[F",             actions.select_first_entry,             { desc = "Open the diff for the first file" } },
          { "n", "]F",             actions.select_last_entry,              { desc = "Open the diff for the last file" } },
          { "n", "gf",             actions.goto_file_edit,                 { desc = "Open the file in the previous tabpage" } },
          { "n", "<C-w><C-f>",     actions.goto_file_split,                { desc = "Open the file in a new split" } },
          { "n", "<C-w>gf",        actions.goto_file_tab,                  { desc = "Open the file in a new tabpage" } },
          { "n", "i",              actions.listing_style,                  { desc = "Toggle between 'list' and 'tree' views" } },
          { "n", "f",              actions.toggle_flatten_dirs,            { desc = "Flatten empty subdirectories in tree listing style" } },
          { "n", "R",              actions.refresh_files,                  { desc = "Update stats and entries in the file list" } },
          { "n", "<leader>e",      actions.focus_files,                    { desc = "Bring focus to the file panel" } },
          { "n", "<leader>b",      actions.toggle_files,                   { desc = "Toggle the file panel" } },
          { "n", "g<C-x>",         actions.cycle_layout,                   { desc = "Cycle available layouts" } },
          { "n", "[x",             actions.prev_conflict,                  { desc = "Go to the previous conflict" } },
          { "n", "]x",             actions.next_conflict,                  { desc = "Go to the next conflict" } },
          { "n", "g?",             actions.help("file_panel"),             { desc = "Open the help panel" } },
          { "n", "<leader>cO",     actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
          { "n", "<leader>cT",     actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
          { "n", "<leader>cB",     actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
          { "n", "<leader>cA",     actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
          { "n", "dX",             actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
        },
        help_panel = {
          { "n", "q",     actions.close,  { desc = "Close help menu" } },
          { "n", "<esc>", actions.close,  { desc = "Close help menu" } },
        },
      },
    })
  end
}

