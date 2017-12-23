USING: kernel assocs sets hashtables graphs strings splitting math.parser fry sequences make
io.files io.encodings.utf8 ;
IN: day12

: take-line ( str graph -- )
    [ " <-> " split1
      [ string>number ]
      [ ", " split-subseq [ string>number ] map ]
      bi*
    ] dip add-vertex ;
: take-lines ( seq graph -- ) '[ _ take-line ] each ;
: lines>graph ( seq -- graph ) H{ } clone [ take-lines ] keep ;
: file>graph ( path -- graph ) utf8 file-lines lines>graph ;

: group-of ( graph node -- nodes ) swap '[ _ at members ] closure ;
: part1 ( graph -- n ) 0 group-of cardinality ;

: group-take! ( graph node -- nodes )
    over swap group-of
    [ members swap '[ _ delete-at ] each ] keep ;

: some-key ( assoc -- elem ) [ 2drop t ] assoc-find 2drop ;

: >groups ( graph -- sets )
    [ [ dup assoc-empty? ] [
          dup dup some-key group-take! ,
      ] until ]
    { } make nip ;
