USING: kernel math sequences io.files io.encodings.utf8 unicode splitting math.parser arrays ;
IN: day02

: rowsum ( seq -- n ) [ supremum ] [ infimum ] bi - ;
: boxsum ( ssq -- n ) [ rowsum ] map sum ;

: wordsplit ( str -- seq ) [ blank? ] split-when-slice [ length 0 > ] filter ;

: the-input ( -- ssq )
    "inputs/day02" utf8 file-lines
    [ wordsplit [ string>number ] map ] map ;

: dor ( ? ? -- ? ) 2dup and f assert= or ;
: maybe-div ( x y -- n/f ) /mod 0 = swap and ;
: rowdiv ( seq -- n )
    dup cartesian-product concat
    [ first2 = not ] filter
    [ first2 maybe-div ] [ dor ] map-reduce ;
: boxdiv ( sseq -- n ) [ rowdiv ] map sum ;
