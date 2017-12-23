USING: kernel math sequences fry ;
IN: day15

! This is noticeably faster with mod instead of rem.
: gen1 ( x g -- x' ) * 2147483647 mod ;
: gen1-step ( a b -- a' b' ) [ 16807 gen1 ] [ 48271 gen1 ] bi* ;
: judge ( a b -- ? ) [ 65535 bitand ] bi@ = ;
: judgen ( a b n quot: ( a b -- a' b' ) -- m )
    [ <iota> ] dip '[ drop @ 2dup judge ] { } filter-as [ 2drop ] dip ; inline
: judgen1 ( a b n -- m ) [ gen1-step ] judgen ;
: part1 ( a b -- n ) 40000000 judgen1 length ;

! So, this is where iterators or optimized lazy lists would be useful.
: gen2a ( x -- x' ) [ dup 3 bitand 0 = ] [ 16807 gen1 ] do until ;
: gen2b ( x -- x' ) [ dup 7 bitand 0 = ] [ 48271 gen1 ] do until ;
: gen2-step ( a b -- a' b' ) [ gen2a ] [ gen2b ] bi* ;
: judgen2 ( a b n -- m ) [ gen2-step ] judgen ;
: part2 ( a b -- n ) 5000000 judgen2 length ;
