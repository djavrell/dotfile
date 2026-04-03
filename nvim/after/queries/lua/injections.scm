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

((function_call
   name: (dot_index_expression
    table: (_) @table
    field: (_) @field
  )
  arguments: (arguments
    (string
      content: (string_content) @injection.content
    )
  )
  (#set! injection.language "vim")
  (#set! injection.include-children)
  )
  (#eq? @table "vim")
  (#eq? @field "cmd")
)
