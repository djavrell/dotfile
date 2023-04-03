require("suit").setup({
  input = {
    -- default prompt value
    default_prompt = 'Input: ',
    -- border of the window (see `:h nvim_open_win`)
    border = 'rounded',
    -- highlight group for input
    hl_input = 'NormalFloat',
    -- highlight group for prompt
    hl_prompt = 'NormalFloat',
    -- highlight group for window border
    hl_border = 'FloatBorder',
    -- input width (in addition to the default value)
    width = 20,
    -- override arguments passed to `nvim_open_win` (see `:h nvim_open_win`)
    nvim_float_api = nil,
  },
  select = {
    -- default prompt value
    default_prompt = 'Select one of: ',
    -- border of the window (see `:h nvim_open_win`)
    border = 'rounded',
    -- highlight group for select list
    hl_select = 'NormalFloat',
    -- highlight group for prompt
    hl_prompt = 'NormalFloat',
    -- highlight group for current selected item
    hl_selected_item = 'PmenuSel',
    -- highlight group for window border
    hl_border = 'FloatBorder',
    -- override arguments passed to `nvim_open_win` (see `:h nvim_open_win`)
    nvim_float_api = nil,
  },
})
