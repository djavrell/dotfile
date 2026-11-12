--- Removes the ••• part.
vim.opt_local.fillchars = 'fold: '

--- Disables fold text.
vim.opt_local.foldtext = ''

vim.opt_local.iskeyword:append({ '-' })
vim.opt_local.textwidth = 80
vim.opt_local.linebreak = true
vim.opt_local.spell = true

--- Shows the ```mermaid block under the cursor as ASCII in a float.
--- mermaid-ascii only knows flowcharts (graph/flowchart) and sequence diagrams; its error is shown as is.
vim.api.nvim_buf_create_user_command(0, 'MermaidAscii', function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]

  local start_row
  for row = cursor_row, 1, -1 do
    if lines[row]:match('^%s*```%s*mermaid') then
      start_row = row
      break
    end
    -- another fence above the cursor: we are outside any mermaid block
    if row < cursor_row and lines[row]:match('^%s*```') then
      break
    end
  end
  local end_row
  for row = (start_row or #lines) + 1, #lines do
    if lines[row]:match('^%s*```%s*$') then
      end_row = row
      break
    end
  end
  if not start_row or not end_row or cursor_row > end_row then
    vim.notify('No mermaid block under the cursor', vim.log.levels.WARN)
    return
  end

  -- mermaid-ascii draws `direction` lines and `A ~~~ B` links as boxes, and prints HTML entities raw:
  -- drop the first, keep the two nodes of the second without a link, decode the third
  local diagram_lines = {}
  for _, line in ipairs(vim.list_slice(lines, start_row + 1, end_row - 1)) do
    if not line:match('^%s*direction%s+%u%u%s*$') then
      line = line:gsub('%s*~~~%s*', '\n'):gsub('&lt;', '<'):gsub('&gt;', '>')
      table.insert(diagram_lines, line)
    end
  end
  local diagram = table.concat(diagram_lines, '\n')
  -- compact: no padding inside boxes, tighter spacing; below -y 4 back edges cross the boxes, -y 1 crashes it
  local command = { 'mermaid-ascii', '-f', '-', '--borderPadding', '0', '--paddingX', '3', '--paddingY', '4' }
  local result = vim.system(command, { stdin = diagram, text = true }):wait()
  local output = result.code == 0 and result.stdout or result.stderr
  local rendered = vim.split(output, '\n', { trimempty = true })

  local width = 1
  for _, line in ipairs(rendered) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  width = math.min(width, vim.o.columns - 4)
  local height = math.min(#rendered, vim.o.lines - 4)

  local float_buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(float_buffer, 0, -1, false, rendered)
  vim.bo[float_buffer].modifiable = false
  local float_window = vim.api.nvim_open_win(float_buffer, true, {
    relative = 'editor',
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = ' mermaid ',
  })
  -- a diagram wider than the screen scrolls sideways instead of breaking its lines
  vim.wo[float_window].wrap = false
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = float_buffer })
end, { desc = 'Render the mermaid block under the cursor as ASCII' })
