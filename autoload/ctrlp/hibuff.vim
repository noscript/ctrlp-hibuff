" File: autoload/ctrlp/hibuff.vim
" Author: Sergey Vlasov <sergey@vlasov.me>
" Last Change: 2014-10-09
" Version: 0.2
"
" Changelog:
" 0.2 default colors

if ( exists('g:loaded_ctrlp_hibuff') && g:loaded_ctrlp_hibuff )
\    || v:version < 700 || &cp
	finish
endif
let g:loaded_ctrlp_hibuff = 1

func HlExists(hl)
	if !hlexists(a:hl)
		return 0
	endif
	redir => hlstatus
		exe "silent hi" a:hl
	redir END
	return (hlstatus !~ "cleared")
endfunc

if !HlExists('CtrlPHiBuffNr')
	hi def link CtrlPHiBuffNr Constant
endif

if !HlExists('CtrlPHiBuffHid')
	hi def link CtrlPHiBuffHid Comment
endif

if !HlExists('CtrlPHiBuffHidMod')
	hi def link CtrlPHiBuffHidMod String
endif

if !HlExists('CtrlPHiBuffVis')
	hi def link CtrlPHiBuffVis Normal
endif

if !HlExists('CtrlPHiBuffVisMod')
	hi def link CtrlPHiBuffVisMod Identifier
endif

if !HlExists('CtrlPHiBuffCur')
	hi def link CtrlPHiBuffCur Question
endif

if !HlExists('CtrlPHiBuffCurMod')
	hi def link CtrlPHiBuffCurMod WarningMsg
endif

if !HlExists('CtrlPHiBuffPath')
	hi def link CtrlPHiBuffPath Comment
endif

cal add(g:ctrlp_ext_vars, {
	\ 'init': 'ctrlp#hibuff#init(s:crbufnr)',
	\ 'accept': 'ctrlp#hibuff#accept',
	\ 'lname': 'hibuff',
	\ 'sname': 'hibuff',
	\ 'type': 'line',
	\ 'sort': 0,
	\ 'specinput': 0,
	\ })

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

fu! ctrlp#hibuff#id()
    retu s:id
endf

fu! ctrlp#hibuff#accept(mode, str)
	let bufnr = matchstr(a:str, '^\s*\zs\d\+')

	if (a:mode == 'h')
		exec ":bd ". bufnr
		call feedkeys("\<f5>")
	else
		call ctrlp#exit()
		exec ":b ". bufnr
	endif
endf

fu! ctrlp#hibuff#init(crbufnr)
	setl cole=2 cocu=nc

	let ids = sort(filter(range(1, bufnr('$')),
		\ 'empty(getbufvar(v:val, "&bt")) &&' .
		\ 'getbufvar(v:val, "&bl")'), 's:compmreb')

	let lines = [[], []]
	for id in ids
		let bname = bufname(id)
		let bname = (bname == '' ? '[No Name]' : bname)
		let flag =
			\ (bufwinnr(id) != -1    ? '*' : '') .
			\ (getbufvar(id, '&mod') ? '+' : '') .
			\ (id == a:crbufnr       ? '!' : '')
		let mark =
			\ (id == bufnr('#')      ? '#' : '') .
			\ (getbufvar(id, '&mod') ? '+' : '')

		let fname = printf('%3s %-2s %-6s%-35s  %s',
			\ id, mark,
			\ '<n>' . flag, '[' . fnamemodify(bname, ':t') .']</n>',
			\ '<p>' . fnamemodify(bname, ':h') . '/' . '</p>')
		cal add(lines[bname], fname)

		if !ctrlp#nosy()
			cal ctrlp#hicheck('HBNr',       'CtrlPHiBuffNr')
			cal ctrlp#hicheck('HBAlt',      'CtrlPHiBuffAlt')
			cal ctrlp#hicheck('HBPath',     'CtrlPHiBuffPath')
			cal ctrlp#hicheck('HBHid',      'CtrlPHiBuffHid')
			cal ctrlp#hicheck('HBHidMod',   'CtrlPHiBuffHidMod')
			cal ctrlp#hicheck('HBVis',      'CtrlPHiBuffVis')
			cal ctrlp#hicheck('HBVisMod',   'CtrlPHiBuffVisMod')
			cal ctrlp#hicheck('HBCur',      'CtrlPHiBuffCur')
			cal ctrlp#hicheck('HBCurMod',   'CtrlPHiBuffCurMod')

			sy match HBNr '\s*\zs\d\+'
			"sy match HBAlt '[+#]*'

			sy region HBRegion  concealends matchgroup=Ignore start='<n>' end='</n>' contains=HBHid,HBHidMod,HBVis,HBVisMod,HBCur,HBCurMod

			sy region HBHid     concealends matchgroup=Ignore start='\s*\['     end='\]' contained
			sy region HBHidMod  concealends matchgroup=Ignore start='+\s*\['    end='\]' contained
			sy region HBVis     concealends matchgroup=Ignore start='\*\s*\['   end='\]' contained
			sy region HBVisMod  concealends matchgroup=Ignore start='\*+\s*\['  end='\]' contained
			sy region HBCur     concealends matchgroup=Ignore start='\*!\s*\['  end='\]' contained
			sy region HBCurMod  concealends matchgroup=Ignore start='\*+!\s*\[' end='\]' contained

			sy region HBPath    concealends matchgroup=Ignore start='<p>' end='</p>'
		en
	endfo

	retu lines[0] + lines[1]
endf

fu! s:compmreb(...)
	" By last entered time (bufnr)
	let [id1, id2] = [
		\ index(ctrlp#mrufiles#bufs(), a:1),
		\ index(ctrlp#mrufiles#bufs(), a:2)]
	retu id1 == id2 ? 0 : id1 > id2 ? 1 : -1
endf

