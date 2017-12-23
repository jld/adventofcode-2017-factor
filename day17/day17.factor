USING: kernel math sequences sequences.extras sequences.rotated arrays fry combinators locals ;
IN: day17

! Representation trick: the state is rotated so that the current
! position is always at the end.

: spinl-new ( -- sl ) V{ 0 } clone ;
: spinl-step! ( sl elt n -- sl ) [ over ] dip rotate! 1array append! ;
: spinnings ( n t -- sl )
    spinl-new -rot <iota> swap
    '[ 1 + _ spinl-step! ] each ;
: part1 ( n -- x ) 2017 spinnings first ;

! This is elegant and also completely fails to work, because it's
! O(n^2) and n is now 50e6.

: untwist ( sl -- seq ) dup 0 swap index <rotated> ;
: bad-part2 ( n -- x ) 50000000 spinnings untwist second ;

! Previously this file contained some hacky tree structures to try to
! allow O(log n)-ish indexed insertion on an explicit representation
! of the state.  It was bad.  The runtime would've been minutes
! instead of decades, which is better but not exactly *good*, and it
! was a lot of code for a problem that turns out to be much simpler:

:: anti-josephus ( ..a n t quot: ( ..a elt i -- ..a ) -- ..a )
    0 t <iota> [ 1 + [ n + ] dip [ mod 1 + ] keep over quot 2curry dip ] each drop ; inline
: (part2) ( n t -- x ) f -rot [ 1 = not -rot ? ] anti-josephus ;
: part2 ( n -- x ) 50000000 (part2) ;
