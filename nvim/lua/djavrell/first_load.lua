local download_packer = function()
  if vim.fn.input("Download packer? (y/n)") ~= "y" then
    return
  end

  local dir = string.format(
    "%s/site/pack/packer/start/",
    vim.fn.stdpath("data")
  )

  vim.fn.mkdir(dir, 'p')

  local result = vim.fn.system(string.format(
    "git clone %s %s",
    "https://github.com/wbthomason/packer.nvim",
    dir .. 'packer.nvim'
  ))

  print(out)
  print("Downloading packer.nvim...")
  print("( You'll need to restart now )")
end

return function()

  if not pcall(require, 'packer') then
    download_packer()
    return true
  end

  return false
end
