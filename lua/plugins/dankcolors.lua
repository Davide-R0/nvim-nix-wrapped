return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#0a1519',
				base01 = '#0a1519',
				base02 = '#96a1a5',
				base03 = '#96a1a5',
				base04 = '#ecf9ff',
				base05 = '#f7fcff',
				base06 = '#f7fcff',
				base07 = '#f7fcff',
				base08 = '#ff89af',
				base09 = '#ff89af',
				base0A = '#79daff',
				base0B = '#91ff9d',
				base0C = '#b8ebff',
				base0D = '#79daff',
				base0E = '#91e0ff',
				base0F = '#91e0ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#96a1a5',
				fg = '#f7fcff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#79daff',
				fg = '#0a1519',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#96a1a5' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#b8ebff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#91e0ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#79daff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#79daff',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#b8ebff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#91ff9d',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#ecf9ff' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#ecf9ff' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#96a1a5',
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
