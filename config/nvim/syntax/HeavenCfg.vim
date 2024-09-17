function! DefineKeywords(keywords)
  for keyword in a:keywords
    execute 'syntax keyword HeavenCfgKeyword '. keyword
  endfor
  hi def link HeavenCfgKeyword Keyword
endfunction

function! DefineSpecial(keywords)
  for keyword in a:keywords
    execute 'syntax keyword HeavenCfgSpecial '. keyword
  endfor
  hi def link HeavenCfgSpecial Special
endfunction

call DefineKeywords( ['DEF', 'I32', 'F32', 'STR', 'BYTES', 'U8', 'CLR', 'VEC2', 'VEC3' ] )

call DefineSpecial( ['map', 'mat'] )

syntax match HeavenCfgVar /\<\w\+\>/
syntax match HeavenCfgString /"[^"]*"/
syntax match HeavenCfgNum /\v\d+(\.\d+)?([eE][+-]?\d+)?/
hi def link HeavenCfgNum Number
hi def link HeavenCfgString String
hi def link HeavenCfgVar Variable
