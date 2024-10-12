function! DefineKeywords(keywords)
  for keyword in a:keywords
    execute 'syntax keyword HolyCKeyword '. keyword
  endfor
  hi def link HolyCKeyword Keyword
endfunction

function! DefineSpecial(keywords)
  for keyword in a:keywords
    execute 'syntax keyword HolyCSpecial '. keyword
  endfor
  hi def link HolyCSpecial Special
endfunction

function! DefineTypes(keywords)
  for keyword in a:keywords
    execute 'syntax keyword HolyCType '. keyword
  endfor
  hi def link HolyCType Type
endfunction

call DefineTypes( [ 'U8', 'U16', 'U32', 'U64', 'I8', 'I16', 'I32', 'I64', 'F32', 'F64', 'Bool', 'U0' ] )
call DefineSpecial( ['Main'] )
call DefineKeywords( [ 'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'break', 'continue', 'return', 'struct', 'union', 'typedef', 'enum', 'const', 'auto', 'static', 'extern', 'public', 'private', 'goto' ] )

syntax match HolyCVar /\<\w\+\>/
syntax match HolyCFunction /\<\w\+\>\s*(\@=/
syntax region HolyCFunctionBody start="(" end=")" contains=HolyCString,HolyCDelimiter,HolyCNum keepend
syntax match HolyCDelimiter /[()]/ containedin=HolyCFunctionBody
syntax match HolyCString /"[^"]*"/
syntax match HolyCNum /\v\d+(\.\d+)?([eE][+-]?\d+)?/
hi def link HolyCVar Variable
hi def link HolyCFunction Function
hi def link HolyCDelimiter Delimiter
hi def link HolyCString String
hi def link HolyCNum Number
