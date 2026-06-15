return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#18111a',
				base01 = '#18111a',
				base02 = '#a399a5',
				base03 = '#a399a5',
				base04 = '#fcefff',
				base05 = '#fdf8ff',
				base06 = '#fdf8ff',
				base07 = '#fdf8ff',
				base08 = '#ff9fac',
				base09 = '#ff9fac',
				base0A = '#f3bbff',
				base0B = '#a5ffbd',
				base0C = '#f9dbff',
				base0D = '#f3bbff',
				base0E = '#f5c7ff',
				base0F = '#f5c7ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#a399a5',
				fg = '#fdf8ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#f3bbff',
				fg = '#18111a',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#a399a5' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#f9dbff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#f5c7ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#f3bbff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#f3bbff',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#f9dbff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffbd',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#fcefff' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#fcefff' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#a399a5',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
