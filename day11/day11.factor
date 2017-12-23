USING: kernel math sorting sequences arrays math.order
hashtables assocs splitting strings
io.files io.encodings.utf8 unicode ;
IN: day11

ERROR: bad-hexdir got ;

! Underdetermined coordinates seem like the least annoying way to do
! this.

: string>hexc ( str -- hexc )
    H{ { "n" { 1 0 0 } }
       { "se" { 0 1 0 } }
       { "sw" { 0 0 1 } }
       { "s" { -1 0 0 } }
       { "nw" { 0 -1 0 } }
       { "ne" { 0 0 -1 } } } ?at
    [ ] [ bad-hexdir ] if ;

: string>hexcs ( str -- seq )
    "," split-subseq [ [ blank? ] trim string>hexc ] map ;

CONSTANT: hexc-zero { 0 0 0 }
: hexc-add ( ha hb -- hc ) [ + ] 2map ;
: hexc-sum ( seq -- h ) hexc-zero [ hexc-add ] reduce ;

: hexc-addnull ( h n -- h ) [ + ] curry map ;
: hexc-excess ( h -- n ) natural-sort second ; ! Probably inefficient, but works.
: hexc-len ( h -- n ) dup hexc-excess neg hexc-addnull [ abs ] map sum ;

: the-input ( -- s ) "inputs/day11" utf8 file-contents string>hexcs ;

: hexc-scansum ( seq -- seq ) hexc-zero swap [ hexc-add dup ] map nip ;
: hexc-farthest ( seq -- n ) [ hexc-len ] map 0 [ max ] reduce ;
