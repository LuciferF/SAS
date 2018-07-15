/*
	Section 3.1 Exercise: Outlier Detection using K-means clustering.

	This exercise illustrates a methodology which can:
	   (a) select a set of seeds that work well on the given data set
	   (b) help identify potential outlier observations.

	A generated  data set (SASUSER.OUTLIERS) will be used. It has only two inputs, x and y, 
    representing each observation's x and y coordinates (respectively). Because the data set
    was generated, the actual cluster membership (given by the variable c) is known.
*/

proc stdize data=sasuser.outliers method=range out=outliers;
	var x y;
run;

ods graphics / height=480px width=480px;

title1 'OUTLIERS Data';
title2 'actual membership';
proc sgplot data=outliers;
	scatter y=y x=x / group=c;
run;

ods graphics / reset=height reset=width;

title1 'Proposed K-Means Solution';
title2 'using the default seeds';
proc fastclus data=outliers maxc=2 least=2 noprint out=results;
   var x y;
run;

ods graphics / height=480px width=480px;

proc sgplot data=results;
	scatter y=y x=x / group=cluster;
run;

ods graphics / reset=height reset=width;

proc fastclus data=outliers maxc=25 maxiter=0 noprint outseed=candidates;
   var x y;
run;

title1 'Gap by Frequency Plot';
proc sgplot data=candidates;
	scatter y=_gap_ x=_freq_;
run;

/* prune low-membership candidates */
data seeds rejected;
	set candidates;
	if _freq_ >= 3 then output seeds;
	else output rejected;
run;

title1 'Proposed K-Means Solution';
title2 'using the selected seeds';
proc fastclus data=outliers maxc=2 seed=seeds least=2 out=results;
   var x y;
run;

ods graphics / height=480px width=480px;

proc sgplot data=results;
	scatter y=y x=x/group=cluster;
run;

ods graphics / reset=height reset=width;
