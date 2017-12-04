USING: kernel sets splitting sequences io.files io.encodings.utf8 unicode ;
IN: day04

: wordsplit ( str -- seq ) [ blank? ] split-when-slice [ empty? not ] filter ;
: passphrase? ( str -- ? ) wordsplit all-unique? ;
: passphrases ( seq -- n ) [ passphrase? ] filter length ;
: the-input ( -- seq ) "inputs/day04" utf8 file-lines ;
