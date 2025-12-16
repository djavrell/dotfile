local autocmd = vim.api.nvim_create_autocmd

local augroups = require('core.augroups.utils')

local parser = {
  'Avante',
  'bash',
  'comment',
  'css',
  'diff',
  'dockerfile',
  'gitattributes',
  'gitcommit',
  'gitconfig',
  'gitrebase',
  'hcl', -- terraform
  'help',
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
  'sh',
  'sql',
  'tsx',
  'typescript',
  'typescript.tsx',
  'vimdoc',
  'yaml',
  'zsh',
}

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
          if not vim.tbl_contains(parser, event.match) then
            return
          end

          local lang = vim.treesitter.language.get_lang(event.match) or event.match
          local buf = event.buf

          -- Start highlighting immediately (works if parser exists)
          pcall(vim.treesitter.start, buf, lang)

          vim.b[buf].foldmethod = 'expr'
          vim.b[buf].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.b[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- Install missing parsers (async, no-op if already installed)
          ts.install({ lang })
        end,
      })
    end,
  },
}
