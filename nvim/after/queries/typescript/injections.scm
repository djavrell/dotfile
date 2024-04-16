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
  (#match? @id "sql")
  (#any-of? @props "fragment")
)

