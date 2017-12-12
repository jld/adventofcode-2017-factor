USING: kernel math sequences namespaces circular fry ;
IN: day06

SYMBOLS: *banks* ;
: run-thing ( ..a seq quot: ( ..a -- ..b ) -- ..b seq )
    [ swap *banks* set call *banks* get ] with-scope ; inline

: inc-bank ( n -- ) *banks* get <circular> 2dup nth 1 + -rot set-nth ;
: biggest ( -- n ) *banks* get [ length <iota> ] [ '[ _ nth ] ] bi supremum-by ;
: take-bank ( n -- m ) *banks* get [ nth ] [ 0 -rot set-nth ] 2bi ;
: redist ( -- ) biggest [ take-bank <iota> ] [ 1 + '[ _ + inc-bank ] ] bi each ;
