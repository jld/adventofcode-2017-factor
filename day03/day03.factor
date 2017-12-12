USING: kernel math math.functions math.order combinators namespaces
sequences assocs hashtables arrays fry ;
IN: day03

: >ring ( n -- n ) 0.5 - sqrt 1 + 2 / >integer ;
: ring-base ( n -- n ) dup 1 - * 4 * 2 + ;
: ring-len ( n -- n ) 2 * 1 max ;
: >sqpolar ( n -- r th ) dup >ring swap over ring-base - ;
: >sqpdir ( n -- r dir dxy ) >sqpolar over ring-len /mod ;
: >sqpoff ( n -- r dir xy ) >sqpdir pick - 1 + ;
: >coords ( n -- x y )
    ! Not actually needed for part 1, but I wrote it anyway.
    >sqpoff swap {
        { 0 [ ] }             ! (x,y) = (r,d)
        { 1 [ neg swap ] }    ! (x,y) = (-d,r)
        { 2 [ [ neg ] bi@ ] } ! (x,y) = (-r,-d)
        { 3 [ swap neg ] }    ! (x,y) = (d,-r)
        { -1 [ 2drop 0 0 ] }
    } case ;
: >manh ( n -- n ) >sqpoff nip abs + ;

! Part 2 is... less elegant.
SYMBOL: the-grid
: with-grid ( ..a quot: ( ..a -- ..b ) -- ..b )
    [ H{ } clone the-grid set call ] with-scope ; inline
: grid@ ( x y -- n ) 2array the-grid get at 0 or ;
: grid! ( n x y -- ) 2array the-grid get set-at ;
: grid-init ( -- ) 1 0 0 grid! ;
: offset ( x y x' y' -- x'' y'' ) rot + [ + ] dip ;
: neighborsum ( x y -- n )
    '[ first2 _ _ offset grid@ + ] 0 swap
    { { 1 0 } { 1 1 } { 0 1 } { -1 1 } { -1 0 } { -1 -1 } { 0 -1 } { 1 -1 } }
    swap each ;
: grid-advance ( x y -- n ) [ neighborsum dup ] [ grid! ] 2bi ;
: grid-attain ( n -- n )
    1 1 ! bound lastnum idx
    [ [ 2dup < ] dip swap ] [ nip 1 + [ >coords grid-advance ] keep ] until
    drop nip ;
: part2 ( n -- n ) [ grid-init grid-attain ] with-grid ;
