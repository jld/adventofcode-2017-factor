USING: kernel math sequences sequences.extras arrays fry ;
IN: day17

! Representation trick: the state is rotated so that the current
! position is always at the end.

: spinl-new ( -- sl ) V{ 0 } clone ;
: spinl-step! ( sl elt n -- sl ) [ over ] dip rotate! 1array append! ;
: spinnings ( n -- sl )
    spinl-new swap 2017 <iota> swap 
    '[ 1 + _ spinl-step! ] each ;
: part1 ( n -- x ) spinnings first ;
