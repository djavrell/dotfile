;; extends
; inherits: ecma

(
  ( call_expression
    (call_expression
      (member_expression
        ( identifier ) @id
        ( property_identifier) @props
        ))
    (template_string) @injection.content
    (#set! injection.language "sql")
    (#set! injection.include-children)
  )
  (#match? @id "sql")
  (#any-of? @props "type" "typeAlias")
)

(
  (call_expression
    (member_expression (
      (identifier) @id
      (property_identifier) @props
    ))
    (template_string) @injection.content
    (#set! injection.language "sql")
    (#set! injection.include-children)
  )
  (#any-of? @id "sql" "Sql")
  (#any-of? @props "fragment")
)


(
  (pair
    (property_identifier) @id
    (template_string) @injection.content
    (#set! injection.language "sql")
    (#set! injection.include-children)
  )
  (#any-of? @id "sqlQuery")
)

(
  (variable_declarator
    (identifier) @id
    (template_string) @injection.content
    (#set! injection.language "sql")
    (#set! injection.include-children)
  )
  (#any-contains? @id "Query" "Part")
)

(
  (assignment_expression
    (identifier) @id
    (template_string) @injection.content
    (#set! injection.language "sql")
  )
  (#any-contains? @id "join" "sql")
)
