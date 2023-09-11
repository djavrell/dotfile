local mergeAll = require("utils.merge").merge_all

local S = {}

---@generic T
---@param data T|nil
---@param fun(T): tables
---@return table
function S.if_def(data, fun)
  if data ~= nil then
    return fun(data)
  end
  return {}
end

---@param nodes table
---@param sep string|nil
---@return table
function S.wrap(nodes, sep)
  if sep ~= nil then
    return mergeAll(
      {{ Text = sep }},
      nodes,
      {{ Text = sep }}
    )
  else
    return nodes
  end
end

---@param nodes table
---@return table
function S.wrapSpace(nodes)
  return S.wrap(
    nodes,
    " "
  )
end

---@param attr table
function S.section(attr)
---@param data table
  return function(data)
    return mergeAll(
      attr,
      data,
      "ResetAttributes"
    )
  end
end

---@param txt string
---@return table
function S.Text(txt)
  return { Text = txt }
end

return S
