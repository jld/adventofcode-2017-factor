USING: kernel math math.parser combinators accessors fry
strings splitting sequences arrays assocs hashtables
io.files io.encodings.utf8 ;
IN: day08

TUPLE: insn insn-dst insn-inc insn-psrc insn-pop insn-pimm ;

: nextword ( str -- rest first ) " " split1 swap ;

: pline ( str -- obj )
    nextword swap
    nextword [ nextword string>number ] dip {
        { "inc" [ ] }
        { "dec" [ neg ] }
    } case swap
    nextword "if" assert=
    nextword swap
    nextword swap
    string>number
    insn boa ;

: pfile ( path -- seq ) utf8 file-lines [ pline ] map ;

: insn-pred ( insn regs -- ? )
    swap [ insn-psrc>> swap at 0 or ] [ insn-pimm>> ] [ insn-pop>> ] tri {
        { "<" [ < ] }
        { ">" [ > ] }
        { "==" [ = ] }
        { "<=" [ <= ] }
        { ">=" [ >= ] }
        { "!=" [ = not ] }
    } case ;

: (do-insn) ( insn regs -- ) [ [ insn-inc>> ] [ insn-dst>> ] bi ] dip at+ ;
: do-insn ( insn regs -- ) 2dup insn-pred [ (do-insn) ] [ 2drop ] if ;

: run1 ( insns -- regs ) H{ } clone [ '[ _ do-insn ] each ] keep ;
: part1 ( insn -- n ) run1 values supremum ;

