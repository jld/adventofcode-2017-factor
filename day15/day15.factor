USING: kernel math sequences ;
IN: day15

! This is noticeably faster with mod instead of rem.
: gen1 ( x g -- x' ) * 2147483647 mod ;
: gen-step ( a b -- a' b' ) [ 16807 gen1 ] [ 48271 gen1 ] bi* ;
: judge ( a b -- ? ) [ 65535 bitand ] bi@ = ;
: judgen ( a b n -- m ) <iota> [ drop gen-step 2dup judge ] { } filter-as [ 2drop ] dip ;
: part1 ( a b -- n ) 40000000 judgen length ;
