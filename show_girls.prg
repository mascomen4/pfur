/* Show the girls who are 20 years and older */
set date Italian
use STUD new

Date_const = CtoD( Str(Day(date())) + '-' + Str(Month(date())) + '-' + Str(Year(date()) - 20))

do while !eof()
if (gender = .f.) .and. (Date_const > dr)
? fio, gender, dr, stip
endif
skip
enddo
