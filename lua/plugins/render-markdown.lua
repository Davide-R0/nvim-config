return {
  'MeanderingProgrammer/render-markdown.nvim',

  dependencies = { 'nvim-tree/nvim-web-devicons', name = 'nvim-web-devicons', enabled = vim.g.have_nerd_font },

  -- Le tue impostazioni vanno qui dentro 'opts'
  opts = {
    -- Headings 
    heading = {
        enabled = true,
        sign = true,
        position = 'overlay',
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        signs = { '󰫎 ' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = false,
        border_virtual = false,
        border_prefix = false,
        above = '▁',
        below = '▔',
        backgrounds = {
            'RenderMarkdownH1Bg', 'RenderMarkdownH2Bg', 'RenderMarkdownH3Bg',
            'RenderMarkdownH4Bg', 'RenderMarkdownH5Bg', 'RenderMarkdownH6Bg',
        },
        foregrounds = {
            'RenderMarkdownH1', 'RenderMarkdownH2', 'RenderMarkdownH3',
            'RenderMarkdownH4', 'RenderMarkdownH5', 'RenderMarkdownH6',
        },
    },

    -- Paragraphs 
    paragraph = {
        enabled = true,
        left_margin = 0,
        min_width = 0,
    },

    -- Code blocks
    code = {
        enabled = true,
        sign = true,
        style = 'full',
        position = 'left',
        language_pad = 0,
        language_name = true,
        disable_background = { 'diff' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = 'thick',
        above = '▄',
        below = '▀',
        highlight = 'RenderMarkdownCode',
        highlight_info = 'RenderMarkdownCode',
        highlight_language = nil,
        highlight_border = false,
        highlight_fallback = 'RenderMarkdownCodeFallback',
        highlight_inline = 'RenderMarkdownCodeInline',
    },

    -- Dash lines
    dash = {
        enabled = true,
        icon = '─',
        width = 'full',
        highlight = 'RenderMarkdownDash',
    },

    -- Bullet lists
    bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
        ordered_icons = function(ctx)
            local value = vim.trim(ctx.value)
            local index = tonumber(value:sub(1, #value - 1))
            return string.format('%d.', index > 1 and index or ctx.index)
        end,
        left_pad = 0,
        right_pad = 0,
        highlight = 'RenderMarkdownBullet',
    },

    -- Checkboxes
    checkbox = {
        enabled = true,
        unchecked = {
            icon = '',
            highlight = 'RenderMarkdownUnchecked',
        },
        checked = {
            icon = '󰄲',
            highlight = 'RenderMarkdownChecked',
        },
        custom = {
            todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownH3', scope_highlight = nil },
            important = { raw = '[~]', rendered = '󰓎 ', highlight = 'DiagnosticWarn' },
        },
    },

    -- Block quotes
    quote = {
        enabled = true,
        icon = '▋',
        repeat_linebreak = true,
        highlight = 'RenderMarkdownQuote',
    },

    -- Tables
    pipe_table = {
        enabled = true,
        preset = 'round',
        style = 'full',
        cell = 'padded',
        padding = 1,
        min_width = 0,
        alignment_indicator = '━',
        head = 'RenderMarkdownTableHead',
        row = 'RenderMarkdownTableRow',
        filler = 'RenderMarkdownTableFill',
    },

    -- Callouts
    callout = {
        note =      { raw = '[!NOTE]',      rendered = '󰋽 Note',        highlight = 'RenderMarkdownInfo' },
        tip =       { raw = '[!TIP]',       rendered = '󰌶 Tip',         highlight = 'RenderMarkdownSuccess' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important',   highlight = 'RenderMarkdownHint' },
        warning =   { raw = '[!WARNING]',   rendered = '󰀪 Warning',      highlight = 'RenderMarkdownWarn' },
        caution =   { raw = '[!CAUTION]',   rendered = '󰳦 Caution',      highlight = 'RenderMarkdownError' },
        abstract =  { raw = '[!ABSTRACT]',  rendered = '󰨸 Abstract',    highlight = 'RenderMarkdownInfo' },
        summary =   { raw = '[!SUMMARY]',   rendered = '󰨸 Summary',      highlight = 'RenderMarkdownInfo' },
        tldr =      { raw = '[!TLDR]',      rendered = '󰨸 Tldr',        highlight = 'RenderMarkdownInfo' },
        info =      { raw = '[!INFO]',      rendered = '󰋽 Info',        highlight = 'RenderMarkdownInfo' },
        todo =      { raw = '[!TODO]',      rendered = '󰗡 Todo',        highlight = 'RenderMarkdownInfo' },
        hint =      { raw = '[!HINT]',      rendered = '󰌶 Hint',        highlight = 'RenderMarkdownSuccess' },
        success =   { raw = '[!SUCCESS]',   rendered = '󰄬 Success',     highlight = 'RenderMarkdownSuccess' },
        check =     { raw = '[!CHECK]',     rendered = '󰄬 Check',        highlight = 'RenderMarkdownSuccess' },
        done =      { raw = '[!DONE]',      rendered = '󰄬 Done',         highlight = 'RenderMarkdownSuccess' },
        question =  { raw = '[!QUESTION]',  rendered = '󰘥 Question',    highlight = 'RenderMarkdownWarn' },
        help =      { raw = '[!HELP]',      rendered = '󰘥 Help',        highlight = 'RenderMarkdownWarn' },
        faq =       { raw = '[!FAQ]',       rendered = '󰘥 Faq',         highlight = 'RenderMarkdownWarn' },
        attention = { raw = '[!ATTENTION]', rendered = '󰀪 Attention',   highlight = 'RenderMarkdownWarn' },
        failure =   { raw = '[!FAILURE]',   rendered = '󰅖 Failure',      highlight = 'RenderMarkdownError' },
        fail =      { raw = '[!FAIL]',      rendered = '󰅖 Fail',        highlight = 'RenderMarkdownError' },
        missing =   { raw = '[!MISSING]',   rendered = '󰅖 Missing',      highlight = 'RenderMarkdownError' },
        danger =    { raw = '[!DANGER]',    rendered = '󱐌 Danger',      highlight = 'RenderMarkdownError' },
        error =     { raw = '[!ERROR]',     rendered = '󱐌 Error',        highlight = 'RenderMarkdownError' },
        bug =       { raw = '[!BUG]',       rendered = '󰨰 Bug',          highlight = 'RenderMarkdownError' },
        example =   { raw = '[!EXAMPLE]',   rendered = '󰉹 Example',      highlight = 'RenderMarkdownHint' },
        quote =     { raw = '[!QUOTE]',     rendered = '󱆨 Quote',        highlight = 'RenderMarkdownQuote' },
        cite =      { raw = '[!CITE]',      rendered = '󱆨 Cite',         highlight = 'RenderMarkdownQuote' },
    },

    -- Links
    link = {
        enabled = true,
        footnote = {
            superscript = true,
            prefix = '',
            suffix = '',
        },
        image = '󰥶 ',
        email = '󰀓 ',
        hyperlink = '󰌹 ',
        highlight = 'RenderMarkdownLink',
        wiki = { icon = '󱗖 ', highlight = 'RenderMarkdownWikiLink' },
        custom = {
            web = { pattern = '^http', icon = '󰖟 ' },
            youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
            github = { pattern = 'github%.com', icon = '󰊤 ' },
            neovim = { pattern = 'neovim%.io', icon = ' ' },
            stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
            discord = { pattern = 'discord%.com', icon = '󰙯 ' },
            reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
        },
    },

    -- Signs
    sign = {
        enabled = true,
        highlight = 'RenderMarkdownSign',
    },

    -- Indents
    indent = {
        enabled = false,
        per_level = 2,
        skip_level = 1,
        skip_heading = true,
    },
  },
}
