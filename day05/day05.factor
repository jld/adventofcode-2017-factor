USING: kernel math sequences namespaces arrays
io.files io.encodings.utf8 math.parser ;
IN: day05

SYMBOL: *program*
: with-prog ( ..a seq quot: ( ..a -- ..b ) -- ..b seq )
    [ swap *program* set call *program* get ] with-scope ; inline

: fetch-and-add ( n -- off/f )
    *program* get 2dup ?nth
    [ [ 1 + -rot set-nth ] [ 2drop ] if* ] keep ;

: step ( n -- n )
    dup fetch-and-add dup [ + ] [ nip ] if ;
: steps ( n -- n )
    0 swap [ dup ] [ step [ 1 0 ? + ] keep ] while drop ;
: part1 ( seq -- n )
    [ 0 steps ] with-prog drop ;

: the-input ( -- seq )
    "inputs/day05" utf8 file-lines [ string>number ] map ;
