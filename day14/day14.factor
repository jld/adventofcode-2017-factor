USING: kernel math math.bitwise math.parser arrays sequences fry ;
FROM: day10 => knothash ;
IN: day14

: keyexpand ( str -- seq )
    128 <iota> swap "-" append '[ number>string _ prepend ] { } map-as ;

: make-grid ( str -- grid ) keyexpand [ knothash ] map ;
: flat-grid ( str -- bytes ) make-grid concat ;
: part1 ( str -- n ) flat-grid [ bit-count ] map sum ;
