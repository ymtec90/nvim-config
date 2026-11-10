local function setup_navic_gruvbox_highlights()
	local colors = {
		bg = "#282828",
		fg = "#ebdbb2",
		gray = "#928374",
		red = "#fb4934",
		green = "#b8bb26",
		yellow = "#fabd2f",
		blue = "#83a598",
		purple = "#d3869b",
		aqua = "#8ec07c",
		orange = "#fe8019",
	}

	local hl_map = {
		NavicText = { fg = colors.fg },
		NavicSeparator = { fg = colors.gray },
		NavicIconsFile = { fg = colors.fg },
		NavicIconsModule = { fg = colors.blue },
		NavicIconsNamespace = { fg = colors.blue },
		NavicIconsPackage = { fg = colors.blue },
		NavicIconsClass = { fg = colors.yellow, bold = true },
		NavicIconsMethod = { fg = colors.green },
		NavicIconsProperty = { fg = colors.blue },
		NavicIconsField = { fg = colors.blue },
		NavicIconsConstructor = { fg = colors.orange },
		NavicIconsEnum = { fg = colors.yellow },
		NavicIconsInterface = { fg = colors.yellow },
		NavicIconsFunction = { fg = colors.green, bold = true },
		NavicIconsVariable = { fg = colors.blue },
		NavicIconsConstant = { fg = colors.purple },
		NavicIconsString = { fg = colors.green },
		NavicIconsNumber = { fg = colors.purple },
		NavicIconsBoolean = { fg = colors.purple },
		NavicIconsArray = { fg = colors.orange },
		NavicIconsObject = { fg = colors.yellow },
		NavicIconsKey = { fg = colors.red },
		NavicIconsNull = { fg = colors.purple },
		NavicIconsEnumMember = { fg = colors.aqua },
		NavicIconsStruct = { fg = colors.yellow },
		NavicIconsEvent = { fg = colors.orange },
		NavicIconsOperator = { fg = colors.fg },
		NavicIconsTypeParameter = { fg = colors.aqua },
	}

	for group, opts in pairs(hl_map) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

-- Registra a execução no ColorScheme
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*gruvbox*",
	callback = setup_navic_gruvbox_highlights,
})

-- Aplica imediatamente na inicialização
setup_navic_gruvbox_highlights()
