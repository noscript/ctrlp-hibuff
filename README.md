#ctrlp-hibuff#

A better buffer explorer for CtrlP

![screenshot](http://raw.github.com/sergey-vlasov/ctrlp-hibuff/master/screen.png)

##Features##

* Everything highlighted
* Buffer numbers
* Relative buffer paths

##Custom Key Binding##

```VimL
nmap <C-B> :CtrlPHiBuff<CR>
```

##Custom Colors##

Available colors:
```
CtrlPHiBuffNr       buffer number
CtrlPHiBuffHid      hidden buffer
CtrlPHiBuffHidMod   hidden and modified buffer
CtrlPHiBuffVis      visible buffer
CtrlPHiBuffVisMod   visible and modified buffer
CtrlPHiBuffCur      current buffer
CtrlPHiBuffCurMod   current and modified buffer
CtrlPHiBuffPath     buffer path
```

Mapping example:
```VimL
hi def link CtrlPHiBuffNr       Constant
hi def link CtrlPHiBuffHid      Comment
hi          CtrlPHiBuffHidMod   guifg=#AC5D2F gui=none
hi def link CtrlPHiBuffVis      Normal
hi          CtrlPHiBuffVisMod   guifg=#FF8800 gui=none
hi          CtrlPHiBuffCur      guifg=#65BDFF gui=bold
hi          CtrlPHiBuffCurMod   guifg=#FF8800 gui=bold
hi def link CtrlPHiBuffPath     Comment
```
