USING: kernel sets splitting sequences io.files io.encodings.ascii ascii sorting ;
IN: day04

: wordsplit ( str -- seq ) [ blank? ] split-when-slice [ empty? not ] filter ;
: passphrase? ( str -- ? ) wordsplit all-unique? ;
: passphrases ( seq -- n ) [ passphrase? ] filter length ;
: the-input ( -- seq ) "inputs/day04" ascii file-lines ;

! I could factor out the common parts, but the quotation effect annotations are too annoying.
: xpass? ( str -- ? ) wordsplit [ natural-sort ] map all-unique? ;
: xpasses ( seq -- n ) [ xpass? ] filter length ;
