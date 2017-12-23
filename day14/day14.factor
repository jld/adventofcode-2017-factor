USING: kernel math math.bitwise math.parser arrays sequences fry ;
FROM: day10 => knothash ;
IN: day14

: keyexpand ( str -- seq )
    128 <iota> swap "-" append '[ number>string _ prepend ] { } map-as ;

: make-grid ( str -- grid ) keyexpand [ knothash ] map ;
: flat-grid ( str -- bytes ) make-grid concat ;
: part1 ( str -- n ) flat-grid [ bit-count ] map sum ;

! This language has bignums, so let's use them:
: pack-line ( bytes -- n ) 0 swap [ [ 256 * ] dip + ] each ;
: pack-grid ( grid -- pg ) [ pack-line ] map ;
: packed-grid ( str -- pg ) make-grid pack-grid ;

: grid-shr ( pg -- pg ) [ 2 /i ] map ;
: grid-shu ( pg -- pg ) rest { 0 } append ;
: grid-and ( pg pg -- pg ) [ bitand ] 2map ;

: line-bits ( n -- seq )
    128 <iota> swap '[ _ swap bit? ] { } filter-as ;
: grid-bits ( grid -- seq )
    128 <iota> [
        [ line-bits ] [ 128 * '[ _ + ] map ] bi*
    ] { } 2map-as concat ;

! The rest of this is the standard union-find algorithm, with path
! compression but without ranking.

: uf-new ( -- uf ) 128 128 * <iota> >array ;
: uf-root? ( n uf -- ? ) over swap nth = ;

: uf-get ( n uf -- m )
    [ swap ] [ nth ] 2bi ! uf n m
    2dup = [ [ 2drop ] dip ] [
        pick uf-get
        [ swap rot set-nth ] keep
    ] if ;

: uf-merge ( n m uf -- )
    [ '[ _ uf-get ] bi@ ] [ set-nth ] bi ;

: link-horiz ( uf grid -- )
    dup grid-shr grid-and grid-bits
    swap '[ dup 1 + _ uf-merge ] each ;
: link-vert ( uf grid -- )
    dup grid-shu grid-and grid-bits
    swap '[ dup 128 + _ uf-merge ] each ;
: link-grid ( uf grid -- )
    [ link-horiz ] [ link-vert ] 2bi ;

: collect-groups ( uf grid -- seq )
    grid-bits swap '[ _ uf-root? ] filter ;

: grid-groups ( grid -- seq )
    uf-new swap [ link-grid ] [ collect-groups ] 2bi ;

: part2 ( str -- n ) packed-grid grid-groups length ;
