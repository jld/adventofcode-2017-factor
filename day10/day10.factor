USING: kernel math sequences locals arrays grouping fry
math.parser splitting
io.encodings.string io.encodings.ascii sequences.repeating ;
IN: day10

: skippingly ( seq -- seq )
    0 swap dup length <iota>
    [| cur len skip | 
     cur len skip + +
     cur dup len + 2array 
    ] { } 2map-as nip ;

! Composing <circular> and <slice> doesn't work because the circular
! passes through the original's length, so the slice thinks wrapped
! indices are out-of-bounds.  But there's <circular-slice>.

: mangle ( seq n -- seq )
    <iota> >array [
        '[ first2 _ <circular-slice> reverse! drop ] each
    ] keep ;

: tangle ( keys -- perm ) skippingly 256 mangle ;

: uncomma ( str -- seq ) "," split-subseq [ string>number ] map ;
: part1 ( str -- n ) uncomma tangle first2 * ;

: elfmagic ( str -- seq ) ascii encode { 17 31 73 47 23 } append ;
: keysched ( str -- seq ) elfmagic dup length 64 * <cycles> ;
: densify ( perm -- bytes )
    '[ 16 * dup 16 + _ <slice> 0 [ bitxor ] reduce ]
    16 <iota> swap map ;

: knothash ( str -- bytes ) keysched tangle densify ;
: hexlate ( bytes -- str ) [ >hex 2 CHAR: 0 pad-head ] map concat ;
: part2 ( str -- str ) knothash hexlate ;

! There's probably a better way to do test vectors, but:
""         part2 "a2582a3a0e66e6e86e3812dcb672a272" assert=
"AoC 2017" part2 "33efeb34ea91902bb2f59c9920caa6cd" assert=
"1,2,3"    part2 "3efbe78a8d82f29979031a4aa0b16a9d" assert=
"1,2,4"    part2 "63960835bcdc130f0b66d7ff4f6a5a8e" assert=
