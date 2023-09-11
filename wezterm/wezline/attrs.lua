local A = {}

---@param attr string
---@return fun(string):table
function A.Attr(attr)
  ---@param text string
  ---@return table
  return function(text)
    return {
      { Attribute = { Intensity = attr } },
      { Text = text }
    }
  end
end

---@param txt string
---@return table
function A.Bold(txt)
  return A.Attr("Bold")(txt)
end

return A
