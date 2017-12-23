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
!
! This was just me being excessively clever in part 1, but in part 2
! it turned out to be a key insight: an Exchange move is the same
! permutation regardless of state, so the usual O(log n) group
! exponentiation thing works, except that the retro-dance and
! antero-dance have to be exponentiated separately and then multiplied
! (D = PQ -> D^n = P^n Q^n -- think about what this word would do if
! you passed it many copies of the original dance).
: unpartner ( dance -- dances )
    [ [ first Partner = ] filter
      [ first3 [ drop Exchange ] 2dip 3array ] map
      reverse! ]
    [ [ first Partner = not ] filter ]
    bi 2array ;

: apply-move ( perm move -- perm )
    dup first {
        { Spin [ second [ tail* ] [ head* ] 2bi append ] }
        { Exchange [ first3 rot drop rot >array [ exchange ] keep ] }
    } case ;

: apply-dance ( perm dance -- perm ) [ apply-move ] each ;

: perm0 ( -- perm ) 16 <iota> >array ;
: perm>string ( perm -- str ) [ CHAR: a + ] map ascii decode ;

: the-input ( -- dance ) "inputs/day16" ascii file-contents string>dance ;
: dance-once ( dances -- perm ) perm0 swap unpartner concat apply-dance ;
: part1 ( dance -- str ) dance-once perm>string ;

: perm* ( perm perm -- perm ) swap [ nth ] curry map ;
: perm-exp ( perm n -- perm )
    { { [ dup 1 = ] [ drop ] }
      { [ dup even? ] [ 2 /i perm-exp dup perm* ] }
      [ over swap 2 /i perm-exp dup perm* perm* ]
    } cond ;

! This is almost a Riverdance joke.
: dance-flatly ( dances -- perms ) [ perm0 swap apply-dance ] map ;
: flatdance-exp ( perms n -- perms ) [ perm-exp ] curry map ;
: perm-product ( perms -- perm ) perm0 [ perm* ] reduce ;
: dance-many ( dance n -- perm ) [ unpartner dance-flatly ] dip flatdance-exp perm-product ;
: part2 ( dance -- str ) 1000000000 dance-many perm>string ;
