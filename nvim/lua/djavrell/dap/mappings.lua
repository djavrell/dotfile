local log = require("djavrell.utils.logger")
local M = {}

function M.global()
end

return setmetatable({}, {
  __index = function(_, k)
    if not M[k] then
      -- log.warn("cannot find mapping for ", k, " adapter", k)
      log.warn("dap.mappings", string.format("cannot find mapping for %s adapter", k))
      return function() end
    else
      return M[k]
    end
  end
})
