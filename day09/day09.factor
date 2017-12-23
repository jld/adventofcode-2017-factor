USING: kernel math strings sequences make regexp combinators
io.files io.encodings.utf8 ;
IN: day09

: cancelize ( str -- str ) R/ !./ "" re-replace ;
: degarbage ( str -- str ) R/ <([^>]*)>/ "" re-replace ;
: rinse ( str -- str ) cancelize degarbage ;

CONSTANT: lbrace CHAR: { CONSTANT: rbrace CHAR: }

: scorify ( str -- seq )
    [ 1 swap
      [ { { lbrace [ 1 + ] }
          { rbrace [ 1 - dup , ] }
          [ drop ] } case
      ] each 1 assert=
    ] { } make ;

: the-input ( -- str ) "inputs/day09" utf8 file-contents ;
: part1 ( str -- seq ) rinse scorify sum ;
