libname ORION '/folders/myfolders/homework#9';
proc import file="/folders/myfolders/homework#9/Home Work 9A.xlsx"
		    out=ORION.mydata
		    DBMS=XLSX
		    REPLACE;
run;
proc kde data=ORION.myData;
   univar c b mixture ;
   title 'Simple KDE procedure';
run;
proc univariate data=ORION.myData;
   var c b mixture;
   histogram / kernel(C=SJPI MISE 0.5); /* three bandwidths */
run;
proc kde data=ORION.myData ; 
   univar c (bwm=0.1) 
          b (bwm=10 ngrid=100)
          mixture / ngrid=200 method=srot;
             title 'KDE procedure with bwm';
             run;
proc kde data=ORION.myData ; 
univar c  b  mixture /plots=densityoverlay;
run;