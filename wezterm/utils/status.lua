local mergeAll = require("utils.merge").merge_all

local C = require("djavrell.colors")

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
---@param cond boolean
---@param sep string
---@return table
function S.wrap(nodes, cond, sep)
  if cond then
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
    true,
    " "
  )
end

---@param text string
---@param space boolean|nil
---@return table
function S.orange_section(text, space)
  if space == nil then space = true end

  return mergeAll(
    {
      { Background = { Color = C.palette.orange.bright } },
      { Foreground = { Color = C.palette.black0 } },
    },
    S.wrap(
      {
        { Attribute = { Intensity = "Bold" } },
        { Text = text }
      },
      space,
      " "
    ),
    { "ResetAttributes" }
  )
end

return S
