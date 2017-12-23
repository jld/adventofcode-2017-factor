USING: kernel math sequences sequences.extras sequences.rotated arrays fry
accessors combinators math.order ;
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

! So let's try something else.

TUPLE: cordage elt left right length ;

: length>>? ( co/f -- n ) [ length>> ] [ 0 ] if* ;
: <cordage> ( elt left right -- co ) 2dup [ length>>? ] bi@ + 1 + cordage boa ;
: cord-take ( co n -- co' )
    { { [ dup 0 <= ] [ 2drop f ] }
      { [ over length>>? over <= ] [ drop ] }
      { [ over left>> length>>? over >= ] [ [ left>> ] dip cord-take ] }
      [ [ drop elt>> ] [ drop left>> ]
        [ over left>> length>>? 1 + - [ right>> ] dip cord-take ]
        2tri <cordage> ]
    } cond ;
: cord-drop ( co n -- co' )
    { { [ dup 0 <= ] [ drop ] }
      { [ over length>>? over <= ] [ 2drop f ] }
      { [ over left>> length>>? over < ]
        [ over left>> length>>? 1 + - [ right>> ] dip cord-drop ] }
      [ [ drop elt>> ] [ [ left>> ] dip cord-drop ] [ drop right>> ]
        2tri <cordage> ]
    } cond ;
: cord-insert ( elt n co -- co' )
    swap [ cord-take ] [ cord-drop ] 2bi <cordage> ;
: cord>array ( co -- seq )
    [ [ left>> cord>array ] [ elt>> 1array ] [ right>> cord>array ]
      tri append append
    ] [ { } ] if* ;

! TODO: balancing?  Right now this will probably be O(n^2/k log n) or so,
! where k is the input and n is large.

TUPLE: vortex position state ;
: <vortex> ( -- vo ) 0 0 f f <cordage> vortex boa ;
: vortex-step ( n vo -- vo' )
    [ position>> + ] [ state>> length>> mod ] [ state>> ] tri vortex boa ;
: vortex-insert ( elt vo -- vo' )
    dup position>> 1 + [ swap state>> cord-insert ] keep swap vortex boa ;
: vortex>array ( vo -- a ) state>> cord>array ;
: vortex-cadr ( vo -- elt ) state>> 2 cord-take 1 cord-drop elt>> ;
: vortex-next ( vo -- elt )
    [ state>> ] [ position>> 1 + ] bi cord-drop 1 cord-take
    [ elt>> ] [ 0 ] if* ;
: vortex-iter ( elt n vo -- vo' ) vortex-step vortex-insert ;
: vorticize ( n t -- vo )
    <vortex> -rot <iota> swap ! vo io n
    '[ 1 + _ rot vortex-iter ] each ;

: cord-depth ( co -- n )
    [ [ left>> cord-depth ] [ right>> cord-depth ] bi max 1 + ] [ 0 ] if* ;
