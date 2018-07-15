%Macro RandG(max_obs=, dist=, outdata=, m=, testnumber=) ;
data &outdata;
call streaminit(123);
do i = 1 to &max_obs;
x = rand &dist;
mu = &dist;
drop i;
output;
end; 
run;
PROC TTEST DATA=&outdata H0=&m;                          
VAR x;
ods output TTests=TTEST&testnumber;
RUN;
%mend RandG;
%RandG(max_obs=500, dist=("normal"), outdata=work.TEST1, m=0, testnumber=1)
%RandG(max_obs=501, dist=("normal"), outdata=work.TEST2, m=0,testnumber=2)
%RandG(max_obs=502, dist=("normal"), outdata=work.TEST3, m=0, testnumber=3)
%RandG(max_obs=503, dist=("normal"), outdata=work.TEST4, m=0, testnumber=4)
%RandG(max_obs=504, dist=("normal"), outdata=work.TEST5, m=0, testnumber=5);
proc sql;
CREATE TABLE ALLTEST AS
SELECT *
FROM WORK.TTEST1
GROUP BY Probt
UNION ALL
SELECT *
FROM WORK.TTEST2
GROUP BY Probt
UNION ALL
SELECT *
FROM WORK.TTEST3
GROUP BY Probt
UNION ALL
SELECT *
FROM WORK.TTEST4
GROUP BY Probt
UNION ALL
SELECT *
FROM WORK.TTEST5
GROUP BY Probt;
run;
proc sgplot data=ALLTEST /* если здесь данные по всем тестам */;
    series x=DF y=probt;
    refline 0.1 0.05 0.01 / axis=y lineattrs=(color=red);
    reg x=DF  y=probt / lineattrs=(color=white);
run;
proc print data = ALLTEST noobs;
run;