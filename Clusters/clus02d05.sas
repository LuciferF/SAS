ods rtf style=htmlbluecml;
proc stdize data=sasuser.elongated method=range 
            out=elongated;
    var x y;
run;

ods graphics / height=480px width=480px;

title1 'Parallel Elongated Clusters';
title2 'Actual Membership';
proc sgplot data=elongated;
   scatter y=y x=x / group=c;
run;

proc fastclus data=elongated maxclusters=2 out=clusout 
              noprint;
     var x y;
run;

title1 'Proposed K-Means Solution (Pre-ACECLUS)';
proc sgplot data=clusout;
   scatter y=y x=x / group=cluster;
run;

title1 'Approximate Covariance Estimation';
proc aceclus data=elongated proportion=.1 maxiter=25 
             out=aceout;
   var x y;
run;

ods graphics / reset=height reset=width;

title2 'ACECLUS Transformed Data';
proc sgplot data=aceout;
   scatter y=can2 x=can1;
   yaxis values=(-9 to 9 by 3);
   xaxis values=(-12 to 12 by 3);
run;

proc fastclus data=aceout maxclusters=2 out=clusout noprint;
   var can:;
run;

title1 'Proposed K-Means Solution (Post-ACECLUS)';
title2 'Displayed on the Transformed Scale';
proc sgplot data=clusout;
   scatter y=can2 x=can1 / group=cluster;
   yaxis values=(-9 to 9 by 3);
   xaxis values=(-12 to 12 by 3);
run;

ods graphics / height=480px width=480px;

title2 'Displayed on the Original Scale';
proc sgplot data=clusout;
   scatter y=y x=x / group=cluster;
run;

ods graphics / reset=height reset=width;
