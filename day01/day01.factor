USING: kernel math sequences sequences.rotated unicode math.parser ;
IN: day01

: digits ( str -- ns ) >graphemes [ string>number ] map ;
: eqsum ( s1 s2 -- n ) [ over = swap 0 ? ] 2map sum ;

: captcha ( str n -- tl ) [ digits dup ] dip <rotated> eqsum ;
: capt1 ( str -- tl ) 1 captcha ;
: capt-half ( str -- tl ) dup length 2 /i captcha ;
