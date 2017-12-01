USING: kernel math sequences unicode math.parser ;
IN: day01

: seqrol ( seq -- seq ) [ rest ] [ first ] bi suffix ;
: digits ( str -- ns ) >graphemes [ string>number ] map ;

: captcha ( str -- tl ) digits dup seqrol [ over = swap 0 ? ] 2map sum ;
