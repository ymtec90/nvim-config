local rainbow_delimiters = require "rainbow-delimiters"

require("rainbow-delimiters.setup").setup {
    strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
    },
    query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
        javascript = "rainbow-delimiters-react",
        javascriptreact = "rainbow-delimiters-react",
        typescript = "rainbow-delimiters-react",
        typescriptreact = "rainbow-delimiters-react",
    },
    highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
    },
}
