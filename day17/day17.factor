USING: kernel math sequences sequences.extras sequences.rotated arrays fry ;
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
