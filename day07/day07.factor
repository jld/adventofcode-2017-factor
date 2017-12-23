USING: kernel math math.parser unicode sequences strings splitting make arrays
io.files io.encodings.utf8 sets hash-sets assocs hashtables fry ;
IN: day07

: pnames ( str -- seq/f ) [ [ dup ] [ ", " split1 swap , ] while drop ] { } make ;
: arrowthing ( str -- seq/f ) " -> " ?head [ pnames ] [ drop f ] if ;
: pline ( str -- obj ) " (" split1 ")" split1 [ string>number ] dip arrowthing 3array ;

: pfile ( path -- seq ) utf8 file-lines [ pline ] map ;

: all-discs ( seq -- set ) [ first ] map >hash-set ;
: upper-discs ( seq -- set ) [ third { } or ] map concat >hash-set ;
: root-discs ( seq -- set ) [ all-discs ] [ upper-discs ] bi diff ;

: tabulate ( seq -- tab ) [ [ first ] keep 2array ] map >hashtable ;
: sprout ( seq -- tabs ) dup [ nip third [ over at ] map! drop ] assoc-each ;
: dendrify ( seq -- trees ) [ root-discs members ] [ tabulate sprout '[ _ at ] ] bi map ;

! I should probably make a tuple class instead of using
! first/second/third like a lazy Lisper or something.

DEFER: aggr
: (aggr) ( tree -- tree ) first3 aggr swap [ + ] dip 3array ;
: aggr ( trees/f -- trees/f n )
    dup [
        0 swap [ (aggr) dup [ second + ] dip ] map swap
    ] [ 0 ] if ;
: aggr* ( trees/f -- trees/f ) aggr drop ;

! At this point I realize that a "normal" implementation would just do
! recursion looking up names in a hashtable and not actually build a
! tree structure or anything.  Oh well.

: alleq? ( seq -- ? ) dup first '[ _ = ] all? ;

DEFER: (imba)
: (imba) ( trees/f -- )
    [ dup [ third (imba) ] each
      dup [ second ] map alleq?
      [ drop ] [ [ first2 2array ] map , ] if
    ] [ ] if* ;
: imba ( trees/f -- seq ) [ (imba) ] { } make ;

: part2 ( seq -- seq ) dendrify aggr* imba ;
