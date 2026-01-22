local autocmd = vim.api.nvim_create_autocmd

local augroups = require('core.augroups.utils')

local parser = {
  'bash',
  'comment',
  'css',
  'diff',
  'dockerfile',
  'gitattributes',
  'gitcommit',
  'hcl', -- terraform
  'javascript',
  'jq',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'regex',
  'scheme',
  'scss',
  'sql',
  'tsx',
  'typescript',
  'vimdoc',
  'yaml',
  'zsh',
}

local ft = vim.tbl_extend('force', parser, {
  'Avante',
  'gitconfig',
  'gitrebase',
  'help',
  'sh',
  'typescript.tsx',
})

---@module "lazy"
---@type LazySpec
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')

      ts.setup({
        install_dir = vim.fn.stdpath('data') .. '/site',
      })
      ts.install(parser)

      autocmd('FileType', {
        group = augroups['tree-sitter'],
        callback = function(event)
          if not vim.tbl_contains(ft, event.match) then
            return
          end

          local winid = vim.api.nvim_get_current_win()
          local lang = vim.treesitter.language.get_lang(event.match) or event.match
          local buf = event.buf

          -- Start highlighting immediately (works if parser exists)
          pcall(vim.treesitter.start, buf, lang)

          vim.wo[winid][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[winid][0].foldmethod = 'expr'
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- Install missing parsers (async, no-op if already installed)
          ts.install({ lang })
        end,
      })
    end,
  },
}
