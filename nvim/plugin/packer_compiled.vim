" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
local package_path_str = "/Users/kpr/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/kpr/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/kpr/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/kpr/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/kpr/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

_G.packer_plugins = {
  ["committia.vim"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/committia.vim"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-better-whitespace"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/vim-better-whitespace"
  },
  ["vim-dadbod"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/vim-dadbod"
  },
  ["vim-dadbod-ui"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/vim-dadbod-ui"
  },
  ["vim-flog"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/vim-flog"
  },
  ["vim-gnupg"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/vim-gnupg"
  },
  ["vim-rest-console"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/vim-rest-console"
  },
  ["vim-troll-stopper"] = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/vim-troll-stopper"
  },
  vimpbcopy = {
    loaded = true,
    path = "/Users/kpr/.local/share/nvim/site/pack/packer/start/vimpbcopy"
  }
}

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
