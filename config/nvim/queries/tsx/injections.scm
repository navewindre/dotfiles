;; Inject CSS into JSX style strings
((jsx_attribute
  (property_identifier) @_prop
  (string
    (string_fragment) @injection.content))
 (#eq? @_prop "style")
 (#set! injection.language "css"))

