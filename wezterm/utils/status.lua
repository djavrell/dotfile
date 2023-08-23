local S = {}

S.KeyGroup = function(window)
  local name = window:active_key_table()
  if name then
    name = 'Key Group: ' .. name
  end
  window:set_right_status(name or '')
end

return S
