((template_string
  (string_fragment) @injection.content)
 (#set! injection.language "sql")
 (#match? @injection.content "^[ \t\r\n]*(SELECT|CREATE|INSERT|UPDATE|DELETE|ALTER|DROP)[ \t\r\n].*(TABLE|COLUMN|FROM|WHERE|VALUES)"))

((template_string
  (string_fragment) @injection.content)
 (#set! injection.language "html")
 (#match? @injection.content "<[a-zA-Z]+[^>]*>"))

