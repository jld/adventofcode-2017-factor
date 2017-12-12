USING: kernel math sequences namespaces circular fry assocs hashtables ;
IN: day06

SYMBOLS: *banks* *history* ;
: run-thing ( ..a seq quot: ( ..a -- ..b ) -- ..b seq )
    [ swap *banks* set
      H{ } clone *history* set
      call
      *banks* get
    ] with-scope ; inline

: inc-bank ( n -- ) *banks* get <circular> 2dup nth 1 + -rot set-nth ;
: biggest ( -- n ) *banks* get [ length <iota> ] [ '[ _ nth ] ] bi supremum-by ;
: take-bank ( n -- m ) *banks* get [ nth ] [ 0 -rot set-nth ] 2bi ;
: redist ( -- ) biggest [ take-bank <iota> ] [ 1 + '[ _ + inc-bank ] ] bi each ;

: assoc-xchg ( value key assoc -- value/f ) 2dup at [ set-at ] dip ;
: memorize ( x -- y/f ) *banks* get clone *history* get assoc-xchg ;

: scenario1 ( -- x ) 0 [ dup memorize ] [ 1 + redist ] until ;
: part1 ( seq -- n ) [ scenario1 ] run-thing drop ;

: scenario2 ( -- x ) 0 [ dup memorize dup ] [ drop 1 + redist ] until - ;
: part2 ( seq -- n ) [ scenario2 ] run-thing drop ;
