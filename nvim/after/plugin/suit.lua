require('suit').setup({
  input = {
    -- default prompt value
    default_prompt = 'Input: ',
    -- border of the window (see `:h nvim_open_win`)
    border = 'single',
    -- highlight group for the input UI window
    -- links to NormalFloat
    hl_win = 'suitWin',
    -- highlight group for the prompt text
    -- links to NormalFloat
    hl_prompt = 'suitPrompt',
    -- highlight group for the window border
    -- links to FloatBorder
    hl_border = 'suitBorder',
    -- input width (in addition to the default value)
    width = 20,
    -- override arguments passed to `nvim_open_win` (see `:h nvim_open_win`)
    nvim_float_api = nil,
  },
  select = {
    -- default prompt value
    default_prompt = 'Select one of: ',
    -- border of the window (see `:h nvim_open_win`)
    border = 'single',
    -- highlight group for the select UI window
    -- links to NormalFloat
    hl_win = 'suitWin',
    -- highlight group for the prompt text
    -- links to NormalFloat
    hl_prompt = 'suitPrompt',
    -- highlight group for the selected item
    -- links to PmenuSel
    hl_sel = 'suitSel',
    -- highlight group for the window border
    -- links to FloatBorder
    hl_border = 'suitBorder',
    -- override arguments passed to `nvim_open_win` (see `:h nvim_open_win`)
    nvim_float_api = nil,
  },
})
