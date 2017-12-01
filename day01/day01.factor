USING: kernel math sequences unicode math.parser ;
IN: day01

: 1seqrol ( seq -- seq ) [ rest ] [ first ] bi suffix ;
: seqrol ( seq n -- seq ) [ tail ] [ head ] 2bi append ;

: digits ( str -- ns ) >graphemes [ string>number ] map ;
: eqsum ( s1 s2 -- n ) [ over = swap 0 ? ] 2map sum ;

: captcha ( str n -- tl ) [ digits dup ] dip seqrol eqsum ;
: capt1 ( str -- tl ) 1 captcha ;
: capt-half ( str -- tl ) dup length 2 /i captcha ;
