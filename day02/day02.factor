USING: kernel math sequences io.files io.encodings.utf8 unicode splitting math.parser ;
IN: day02

: rowsum ( seq -- n ) [ supremum ] [ infimum ] bi - ;
: boxsum ( ssq -- n ) [ rowsum ] map sum ;

: wordsplit ( str -- seq ) [ blank? ] split-when-slice [ length 0 > ] filter ;

: the-input ( -- ssq )
    "inputs/day02" utf8 file-lines
    [ wordsplit [ string>number ] map ] map ;
