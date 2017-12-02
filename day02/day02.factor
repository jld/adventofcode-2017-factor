USING: kernel math sequences ;
IN: day02

: rowsum ( seq -- n ) [ supremum ] [ infimum ] bi - ;
: boxsum ( seqseq -- n ) [ rowsum ] map sum ;
