local has_dap, dap = pcall(require, "dap")
if not has_dap then
  return
end

local Hydra = require('hydra')
local augroups = require('djavrell.augroups.utils')

dap.adapters['pwa-node'] = {
        type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          os.getenv("HOME") .. "/bin/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
}

require("dap").configurations.typescript = {
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach",
    processId = require'dap.utils'.pick_process,
    cwd = "${workspaceFolder}",
  }
}

local map = function(lhs, rhs, desc)
  if desc then
    desc = "[DAP] " .. desc
  end

  vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

local function b(action)
  return string.format("require('dap').%s", action)
end

local hint = [[
  _b_: break point _db_: cond
  _c_: continue _I_: in _o_: over _O_: out _B_: back
]]

Hydra({
  name = 'Debugger',
  hint = hint,
  config = {
    color = 'pink',
    invoke_on_body = 'true',
    hint = {
      position = 'top'
    }
  },
  mode = 'n',
  body = '<leader>d',
  heads = {
    { 'b',  require('dap').toggle_breakpoint },
    { 'B',  require("dap").step_back },
    { 'I',  require("dap").step_into },
    { 'o',  require("dap").step_over },
    { 'O',  require("dap").step_out },
    { 'c',  require('dap').continue },
    { 'e',  require("dapui").eval },
    { 'db', function() require('dap').set_breakpoint(vim.fn.input "[DAP] Condition > ") end },
    { 'dl', function() require('dap').set_breakpoint(nil, nil, vim.fn.input "[DAP] Log > ") end },
    { 'E',  function() require("dapui").eval(vim.fn.input "[DAP] Expression > ") end }
  }
})

map("<F1>", require("dap").step_back, "step_back")
map("<F2>", require("dap").step_into, "step_into")
map("<F3>", require("dap").step_over, "step_over")
map("<F4>", require("dap").step_out, "step_out")
map("<F5>", require("dap").continue, "continue")

-- TODO:
-- disconnect vs. terminate

map("<leader>dr", require("dap").repl.open)

map("<leader>db", require("dap").toggle_breakpoint)
map("<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input "[DAP] Condition > ")
end)
map("<leader>dl", function()
  require("dap").set_breakpoint(nil, nil, vim.fn.input "[DAP] Log > ")
end)

map("<leader>de", require("dapui").eval)
map("<leader>dE", function()
  require("dapui").eval(vim.fn.input "[DAP] Expression > ")
end)

require("nvim-dap-virtual-text").setup {
  enabled = true,

  -- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
  enabled_commands = true,

  -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_changed_variables = true,
  highlight_new_as_changed = true,

  -- prefix virtual text with comment string
  commented = false,

  show_stop_reason = true,

  -- experimental features:
  virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
  all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
}

-- You can set trigger characters OR it will default to '.'
-- You can also trigger with the omnifunc, <c-x><c-o>
vim.api.nvim_create_autocmd("FileType", {
  group = augroups["dap"],
  pattern = "dap-repl",
  callback = function()
    require("dap.ext.autocompl").attach()
  end
})

local dap_ui = require "dapui"

dap_ui.setup {
  layouts = {
    {
      elements = {
        { id = "watches", size = 0.5 },
        "scopes",
        { id = "breakpoints", size = 0.10 }
      },
      size = 0.25,
      position = "left"
    },
    {
      elements = { "repl", "console" },
      size = 0.15,
      position = "bottom"
    },
  }
}

dap.listeners.after.event_initialized["dapui_config"] = function()
  dap_ui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dap_ui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dap_ui.close()
end
