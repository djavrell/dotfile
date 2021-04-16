require("packer").startup {
  function(use)
    -- functional
    use 'wbthomason/packer.nvim'
    use 'tjdevries/astronauta.nvim' -- autoload file in lua/plugin and after/plugin
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    -- UI
    use {
       'kyazdani42/nvim-tree.lua',
       requires = {{ 'kyazdani42/nvim-web-devicons'}}
    }

    -- Tree Sitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      requires = {
        {'nvim-treesitter/playground'}
      }
    }
    use 'christianchiarulli/nvcode-color-schemes.vim'

    -- better life in nvim
    use 'benknoble/vimpbcopy'
    use 'ntpeters/vim-better-whitespace'
    use 'vim-utils/vim-troll-stopper'

    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        {'nvim-lua/popup.nvim'},
        {'nvim-lua/plenary.nvim'}
      }
    }

    -- security
    use 'jamessan/vim-gnupg'

    -- Git
    use 'rhysd/committia.vim'
    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      }
    }

    -- DB
    use 'tpope/vim-dadbod'
    use 'kristijanhusak/vim-dadbod-ui'

    -- Http Query
    use 'diepm/vim-rest-console'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-compe'
    use 'nvim-lua/completion-nvim'
    use 'nvim-lua/lsp-status.nvim'
    use 'glepnir/lspsaga.nvim'
    use 'onsails/lspkind-nvim'

    -- Languages
    -- Lua
    use 'euclidianAce/BetterLua.vim'
    use 'tjdevries/nlua.nvim'

  end,
  config = {
    display = {
      open_cmd = "100vnew [packer]"
    }
  }
}
