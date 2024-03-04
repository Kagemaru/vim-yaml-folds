function! YamlFolds()
  let previous_level = indent(prevnonblank(v:lnum - 1)) / &shiftwidth
  let current_level = indent(v:lnum) / &shiftwidth
  let next_level = indent(nextnonblank(v:lnum + 1)) / &shiftwidth
  
  let current_line = getline(v:lnum)
  let next_line = getline(v:lnum+1)
  
  if current_line =~ '^---$'
    return ">1"

elseif current_line =~ '^...$'
    return "<1"

  elseif next_line =~ '^\s*$'
    return "="

  elseif current_level < next_level
    return next_level

  elseif current_level > next_level
    return ('s' . (current_level - next_level))

  elseif current_level == previous_level
    return "="

  endif

  return next_level
endfunction

function! YamlFoldText()
  let lines = v:foldend - v:foldstart

  let first_line = getline(v:foldstart)
  let second_line = getline(v:foldstart+1)

  if first_line =~ '^---$'
    return second_line . '   (level ' . v:foldlevel . ', lines ' . lines . ')'
  else
    return first_line . '   (level ' . v:foldlevel . ', lines ' . lines . ')'
  endif
endfunction


setlocal foldmethod=expr
setlocal foldexpr=YamlFolds()
setlocal foldtext=YamlFoldText()

let b:undo_ftplugin =
      \ exists('b:undo_ftplugin')
        \  ? b:undo_ftplugin . ' | '
        \ : ''
      \ . 'setlocal foldexpr< foldmethod< foldtext<'
