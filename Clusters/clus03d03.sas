/*clus03d03.sas*/
/* 
	Apply nonparametric clustering to the RING data set, which is often used as 
    a benchmark test of clustering algorithms. Because this is an artificial data 
    set, the actual cluster membership is known. The actual membership is given by 
    the variable c. There are two input variables, x and y, representing the x and
    y coordiates of each observation.
*/

/* standardize the input data */
proc stdize data=sasuser.ring method=range out=ring;
	var x y;
run;

/* display the actual cluster membership */
ods graphics / height=480px width=480px;
title1 'Actual Membership';
proc sgplot data=ring;
   	scatter y=y x=x/group=c;
run;

/* generate the k-means solution */
title1 'K-Means Clustering';
proc fastclus data=ring maxclusters=2 least=2 noprint out=results;
	var x y;
run;

/* display the proposed k-means solution */
title2 'Derived Clusters';
proc sgplot data=results;
	scatter y=y x=x/group=cluster;
run;

ods graphics / reset=height reset=width;

/* generate the nonparametric solution */
title1 'Nonparametric Clustering';
proc modeclus data=ring method=1 r=0.1 join out=results;
	var x y;
run;

/* display the proposed nonparametric solution (by join level) */
title2 'Derived Clusters';
proc sgpanel data=results;
	panelby _njoin_;
	scatter y=y x=x/group=cluster;
run;

