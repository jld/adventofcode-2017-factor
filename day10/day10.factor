USING: kernel math sequences locals arrays grouping fry
math.parser splitting ;
IN: day10

: skipify ( seq -- seq )
    0 swap dup length <iota>
    [| cur len skip | 
     cur len skip + +
     cur dup len + 2array 
    ] 2map nip ;

! Composing <circular> and <slice> doesn't work because the circular
! passes through the original's length, so the slice thinks wrapped
! indices are out-of-bounds.  But there's <circular-slice>.

: mangle ( seq n -- seq )
    <iota> >array [
        '[ first2 _ <circular-slice> reverse! drop ] each
    ] keep ;

: uncomma ( str -- seq ) "," split-subseq [ string>number ] map ;

: part1 ( seq -- n ) skipify 256 mangle first2 * ;
