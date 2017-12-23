USING: kernel accessors math math.order sequences
math.parser strings splitting io.files io.encodings.utf8 ;
IN: day13

TUPLE: firelayer depth range ;

: severity>> ( layer -- n ) [ depth>> ] [ range>> ] bi * ;
: scanlate ( n range -- m ) 1 - [ + ] [ 2 * 1 max rem ] [ - ] tri abs ;

! The [ scanlate 0 = ] that emerges from the next two definitions
! could be [ 1 - 2 * 1 max rem 0 = ] or something and that might be
! faster, since it turns out in part 2 we don't ever care about the
! sawtooth function aside from its zeros.
: scan-pos ( layer offset -- n ) swap [ depth>> + ] [ range>> scanlate ] bi ;
: caught? ( layer offset -- ? )  scan-pos 0 = ;
: caughtness ( layer offset -- n ) over swap caught? [ severity>> ] [ drop 0 ] if ;
: caughtnesses ( layers offset -- ns ) [ caughtness ] curry map ;
: part1 ( layers -- n ) 0 caughtnesses sum ;

: pline ( str -- layer ) ": " split1 [ string>number ] bi@ firelayer boa ;
: pfile ( path -- layers ) utf8 file-lines [ pline ] map ;

! There's probably a Chinese Remainder Theorem approach that'd be
! faster, but brute force is fast enough in practice.
: ever-caught? ( layers offset -- ? ) [ caught? ] curry any? ;
: part2 ( layers -- n ) 0 [ 2dup ever-caught? ] [ 1 + ] while nip ;
