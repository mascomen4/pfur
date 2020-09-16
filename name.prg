set date Italian
st={{'fio','C',15,0},{'gender','L',1,0},{'dr','D',8,0},{'stip','N',8,2}}
dbcreate('STUD', st)
use STUD new
append blank
replace fio with 'Ivanov', gender with .t., dr with ctod('06-09-1999'), stip with 1500
append blank
replace fio with 'Lorem', gender with .f., dr with ctod('06-09-2000'), stip with 1600
append blank
replace fio with 'Dok', gender with .t., dr with ctod('06-09-2001'), stip with 1700
append blank
replace fio with 'Zak', gender with .f., dr with ctod('06-09-1998'), stip with 1800
append blank
replace fio with 'Bok', gender with .t., dr with ctod('06-09-1997'), stip with 1900
append blank
replace fio with 'Lok', gender with .f., dr with ctod('06-09-1996'), stip with 2000
append blank
replace fio with 'Zok', gender with .f., dr with ctod('06-09-1995'), stip with 1400
append blank
replace fio with 'Sok', gender with .t., dr with ctod('06-09-1994'), stip with 900
append blank
replace fio with 'Jok', gender with .t., dr with ctod('06-09-1999'), stip with 2000
append blank
replace fio with 'Kok', gender with .f., dr with ctod('06-09-1998'), stip with 900
append blank
replace fio with 'Hok', gender with .t., dr with ctod('06-09-1997'), stip with 800
append blank
replace fio with 'Mok', gender with .t., dr with ctod('06-09-1996'), stip with 15000
append blank
replace fio with 'Tok', gender with .t., dr with ctod('06-09-1995'), stip with 15000
append blank
replace fio with 'Rok', gender with .t., dr with ctod('06-09-1994'), stip with 3000
append blank
replace fio with 'Joseph', gender with .f., dr with ctod('06-09-1998'), stip with 1300
append blank
replace fio with 'Kevin', gender with .t., dr with ctod('06-09-1995'), stip with 1500
append blank
replace fio with 'Mike', gender with .t., dr with ctod('06-09-1999'), stip with 1500
