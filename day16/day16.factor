USING: kernel math strings splitting math.parser ascii
sequences sequences.rotated arrays combinators
io.files io.encodings.string io.encodings.ascii ;
IN: day16

SYMBOLS: Spin Exchange Partner ;

: string>move ( str -- move )
    [ rest ] [ first ] bi {
        { CHAR: s [ string>number Spin swap 2array ] }
        { CHAR: x [ "/" split1 [ string>number ] bi@ Exchange -rot 3array ] }
        { CHAR: p [ "/" split1 [ first CHAR: a - ] bi@ Partner -rot 3array ] }
    } case ;

: string>dance ( str -- dance )
    "," split-subseq [ [ blank? ] trim string>move ] map ;

! Appending a Partner move is equivalent to prepending an Exchange
! move, causing the swapped partners to have always already been
! swapped.
: unpartner ( dance -- dance )
    [ [ first Partner = ] filter
      [ first3 [ drop Exchange ] 2dip 3array ] map
      reverse! ]
    [ [ first Partner = not ] filter ]
    bi append ;

: apply-move ( perm move -- perm )
    dup first {
        { Spin [ second [ tail* ] [ head* ] 2bi append ] }
        { Exchange [ first3 rot drop rot >array [ exchange ] keep ] }
    } case ;

: apply-dance ( perm dance -- perm ) [ apply-move ] each ;

: perm0 ( -- perm ) 16 <iota> >array ;
: perm>string ( perm -- str ) [ CHAR: a + ] map ascii decode ;

: the-input ( -- dance ) "inputs/day16" ascii file-contents string>dance ;
: part1 ( dance -- str ) perm0 swap unpartner apply-dance perm>string ;
