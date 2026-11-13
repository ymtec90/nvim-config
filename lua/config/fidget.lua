local M = {}

M.opts = {
    progress = {
        support_on_insert = true,
        ignore_done_already = true,
        ignore_empty_message = true,
        display = {
            done_ttl = 2,
            done_icon = "",
            progress_icon = { "dots" },
        },
    },
    notification = {
        override_vim_notify = false,
        window = {
            winblend = 0,
            border = "none",
            align = "bottom",
            h_align = "right",
            x_padding = 1,
            y_padding = 1,
        },
    },
}

return M
