set date Italian
use STUD new
do while !eof()
if gender = .t.
? fio, gender, dr, stip
endif
skip
enddo
