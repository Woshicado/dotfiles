return {
	"Goose97/timber.nvim",
	version = "*",
	opts = {},
	event = "VeryLazy",
	config = function()
		require("timber").setup({
			log_marker = "🪵",
			log_templates = {
				default = {
					lua = [[print("%watcher_marker_start" .. %log_target .. "%watcher_marker_end")]],
					python = [[print(f"%watcher_marker_start|\033[0;32m{%log_target=}\033[0m|%watcher_marker_end")]],
				},
				file = {
					python = [[print(f"%watcher_marker_start|LOG \033[0;32m{%log_target=}\033[0m ON LINE \033[0;33m%filename:%line_number\033[0m|%watcher_marker_end")]],
				},
				time_start = {
					lua = [[local _start = os.time()]],
					python = [[import time; _start = time.perf_counter()]],
				},
				time_end = {
					lua = [[print("Elapsed time: " .. tostring(os.time() - _start) .. " seconds")]],
					python = [[print(f"%watcher_marker_start|Elapsed time: \033[0;34m{time.perf_counter() - _start}\033[0m seconds|%watcher_marker_end")]],
				},
				pretty = {
					python = {
						[[print(f"%watcher_marker_start|\033[0;32m%log_target = {pformat(%log_target)}\033[0m|%watcher_marker_end")]],
						auto_import = [[from pprint import pformat]],
					},
				},
			},
			batch_log_templates = {
				default = {
					python = [[print(f"%watcher_marker_start|\033[0;32m%repeat<{%log_target=}><, >\033[0m|%watcher_marker_end")]],
				},
			},
			log_watcher = {
				enabled = true,
				sources = {
					log_file = {
						type = "filesystem",
						name = "Log file",
						path = "/tmp/debug.log",
					},
				},
			},
		})
	end,
}

