************ CHECKING FOR MISSING VALUES ************;
proc iml;
use ORION.TRAINING;
read all var _NUM_ into x[colname=nNames]; 
n = countn(x,"col");
nmiss = countmiss(x,"col");
read all var _CHAR_ into x[colname=cNames]; 
close ORION.TRAINING;
c = countn(x,"col");
cmiss = countmiss(x,"col");
/* combine results for num and char into a single table */
Names = cNames || nNames;
rNames = {"    Missing", "Not Missing"};
cnt = (cmiss // c) || (nmiss // n);
print cnt[r=rNames c=Names label=""];
proc print data = ORION.TRAINING(WHERE=(VIN_1 = ''));
run;