local T = require("utils.tables")

local S = {}

---@generic T
---@param data T|nil
---@param fun(T): wezline.Attr[]
---@return wezline.Attr[]
function S.if_def(data, fun)
  if data ~= nil then
    return fun(data)
  end
  return {}
end

---@param nodes wezline.Attr[]
---@param sep string|nil
---@return wezline.Attr[]
function S.wrap(nodes, sep)
  if sep ~= nil then
    return T.merge_all(
      {{ Text = sep }},
      nodes,
      {{ Text = sep }}
    )
  else
    return nodes
  end
end

---@param nodes wezline.Attr[]
---@return wezline.Attr[]
function S.wrapSpace(nodes)
  return S.wrap(
    nodes,
    " "
  )
end

---@param attr wezline.Attr[]
function S.section(attr)
---@param data wezline.Attr[]
---@return wezline.Attr[]
  return function(data)
    return T.merge_all(
      attr,
      data,
      "ResetAttributes"
    )
  end
end

---@param txt string
---@return wezline.Attr.Text
function S.Text(txt)
  return { Text = txt }
end

return S
