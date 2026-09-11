vim.cmd([[
  try
    source $XDG_CONFIG_HOME/local_nvim.vim
  catch
    let mapleader = '!'
    let maplocalleader = '!'
  endtry

  filetype plugin indent on
]])

require('core.globals')
require('core.lazy_init')
-- require('core.options')
require('core.augroups')
require('core.commands')

require('vim._core.ui2').enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = 'cmd',
    dialog = { -- Options related to dialog window.
      height = 0.5, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.5, -- Maximum height.
    },
    pager = { -- Options related to message window.
      height = 1, -- Maximum height.
    },
  },
})

vim.cmd([[
    set messagesopt+=maxheight:50,timeout:4000
]])
