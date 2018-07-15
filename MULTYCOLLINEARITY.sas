proc sql;
Create table DELETED_VAR as 
SELECT * FROM BodyFat WHERE Var_Num in (39, 221, 22, 40, 80, 171, 191, 206, 223, 236, 247, 248);
run;
proc reg data=DELETED_VAR ;
model pctbodyfat = Abdomen Weight Wrist Forearm Neck/ vif tol collinoint;
title 'Multicollinearity analysis';
run;
proc corr data=DELETED_VAR ;
var pctbodyfat Abdomen Weight Wrist Forearm Neck;
title 'Multicollinearity analysis';
run;
proc reg data=DELETED_VAR ;
model pctbodyfat = Abdomen  Wrist Forearm  / vif tol collinoint;
run;
proc corr data=DELETED_VAR SPEARMAN;
var Abdomen Wrist Forearm;
run;