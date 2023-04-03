;; extends

((function_call
  name: (_) @autocmd
  arguments: (arguments
               (_)
               (table_constructor (field
                                    name: (_) @key
                                    value: (string content: _ @vim))
               ))
  )
 (#any-of? @autocmd "autocmd" "api.nvim_create_autocmd" "vim.api.nvim_create_autocmd")
 (#eq? @key "command")
)
