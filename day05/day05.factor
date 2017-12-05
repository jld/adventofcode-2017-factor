USING: kernel math sequences namespaces arrays
io.files io.encodings.utf8 math.parser ;
IN: day05

SYMBOLS: *program* *limit* ;
: with-prog ( ..a seq quot: ( ..a -- ..b ) -- ..b seq )
    [ swap *program* set call *program* get ] with-scope ; inline

: over-limit? ( n -- ? )
    *limit* get dup [ >= ] [ nip ] if ;
: maybe-inc ( n -- n )
    dup over-limit? -1 1 ? + ;

: fetch-and-add ( n -- off/f )
    *program* get 2dup ?nth
    [ [ maybe-inc -rot set-nth ] [ 2drop ] if* ] keep ;

: step ( n -- n )
    dup fetch-and-add dup [ + ] [ nip ] if ;
: steps ( n -- n )
    0 swap [ dup ] [ step [ 1 0 ? + ] keep ] while drop ;
: part1 ( seq -- n )
    [ 0 steps ] with-prog drop ;
: part2 ( seq -- n )
    [ 3 *limit* set 0 steps ] with-prog drop ;

: the-input ( -- seq )
    "inputs/day05" utf8 file-lines [ string>number ] map ;
