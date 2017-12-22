USING: kernel math math.parser unicode sequences strings splitting make arrays
io.files io.encodings.utf8 sets hash-sets ;
IN: day07

: pnames ( str -- seq/f ) [ [ dup ] [ ", " split1 swap , ] while drop ] { } make ;
: arrowthing ( str -- seq/f ) " -> " ?head [ pnames ] [ drop f ] if ;
: pline ( str -- obj ) " (" split1 ")" split1 [ string>number ] dip arrowthing 3array ;

: pfile ( path -- seq ) utf8 file-lines [ pline ] map ;

: all-discs ( seq -- set ) [ first ] map >hash-set ;
: upper-discs ( seq -- set ) [ third { } or ] map concat >hash-set ;
: root-discs ( seq -- set ) [ all-discs ] [ upper-discs ] bi diff ;

