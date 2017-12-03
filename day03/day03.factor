USING: kernel math math.functions math.order combinators ;
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
