require("smear_cursor").setup({
	-- Comportamento rápido e sem rebote (estilo Kitty cursor_trail / iTerm2)
	stiffness = 0.8, -- Padrão: 0.6 (ponta do cursor acompanha quase instantaneamente)
	trailing_stiffness = 0.6, -- Padrão: 0.45 (cauda alcança rápido sem atraso excessivo)
	stiffness_insert_mode = 0.7, -- Padrão: 0.5
	trailing_stiffness_insert_mode = 0.7, -- Padrão: 0.5
	damping = 0.95, -- Padrão: 0.85 (elimina o efeito elástico/rebote ao parar)
	damping_insert_mode = 0.95, -- Padrão: 0.9
	distance_stop_animating = 0.5, -- Padrão: 0.1 (encerra a animação de forma limpa)

	-- Suavidade visual no Kitty (usa glifos Unicode de sub-célula para evitar degraus)
	legacy_computing_symbols_support = true,

	-- Onde animar
	smear_between_buffers = true,
	smear_between_neighbor_lines = true,
	smear_insert_mode = true,
	scroll_buffer_space = true,

	-- Mantém o cursor nativo visível na posição final para evitar sensação de latência
	hide_target_hack = false,
})
