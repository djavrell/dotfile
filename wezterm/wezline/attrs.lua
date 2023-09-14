local wez = require('wezterm')
local log = wez.log_info

local T = require("utils.tables")

local A = {}

---@generic T
---@param kind string
---@param opt table<`T`>
local kindMeta = function(kind, opt)
  return setmetatable(opt, {
    ---@param t table<`T`>
    ---@param k string
    __index = function(t, k)
      local ret = {}
      if T.include(t, k) then
         ret[kind] = k
         return ret
      end
    end
  })
end

local AttributesMeta = setmetatable({
  Underline = kindMeta("Underline", { "None", "Single", "Double", "Curly", "Dotted", "Dashed" }),
  Intensity = kindMeta("Intensity", { "Normal", "Bold", "Half" }),
  Italic = kindMeta("Italic", {
    True = { Italic = true },
    False = { Italic = false },
  }),
}, {
  __index = function(t, k)
    if t[k] ~= nil then
      return t[k]
    end
    return k
  end
})


local colorKindMeta = function(kind)
  local ColorKind = function(t)
    local ret = {}
    ret[kind] = {}

    return function(color)
      ret[kind][t] = color
      return ret
    end
  end

  return setmetatable({ "Color", "ColorAnsi" }, {
    __index = function (t, key)
      if T.include(t, key) then
        return ColorKind(key)
      end
    end,
  })
end

A.Nodes = setmetatable({
  Attributes = AttributesMeta,
  Foreground = colorKindMeta("Foreground"),
  Background = colorKindMeta("Background"),
  Text = function(txt)
    return { Text = txt }
  end,
  ResetAttributes = "ResetAttributes"
}, {
  __index = function(t, k)
    if t[k] ~= nil then
      return t[k]
    end
    error(k .. " is not a valide Node.")
  end
})

---@param attr string
---@return fun(string): wezline.Attr[]
function A.Attr(attr)
  ---@param text string
  ---@return wezline.Attr[]
  return function(text)
    return {
      { Attribute = { Intensity = attr } },
      { Text = text }
    }
  end
end

---@param txt string
---@return wezline.Attr.Attributes
function A.Bold(txt)
  return A.Attr("Bold")(txt)
end

return A
