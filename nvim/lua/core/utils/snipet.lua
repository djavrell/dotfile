local M = {}

function M.capitalize(args, parent, user_args)
   return (args[1][1]:gsub("^%l", string.upper))
end


return M
