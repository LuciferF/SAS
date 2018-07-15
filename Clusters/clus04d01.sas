/*clus04d01.sas*/
/*
	Comparing hierarchical clustering methods

	This demonstration compares the performance of a specified set of hierarchical clustering methods.

    In this case the sasuser.pizza data set, discussed previously, will be clustered. The three inputs
    recommended by the 1-R**2 criterion of PROC ACECLUS will be used as input. The comparison class is
    the brand of pizza from which the sample was extracted. The performance of the methods are sorted 
    by (descending) Cramer's V value and (ascending) number of misclassifications.

	NOTE: This macro does not support Wong's HYBRID method.
*/



%let inputs=carb mois sodium;	/* input variables (recommended by PROC ACECLUS)*/
%let group=brand;				/* comparison class (10 pizza brands) */

%macro hierarchical(dsn=,method=,nc=);
	title1 "&method";
	%if %upcase(&method)=EML %then %do;
		proc cluster data=&dsn method=eml notie outtree=tree;
			var &inputs;
			copy &group;
		run;
	%end;
	%else %do;
		proc distance data=&dsn method=euclid out=distances;
			var interval(&inputs); 
			copy &group;
		run;
		proc cluster data=distances method=&method notie outtree=tree;
			var dist:;
			copy &group;
		run;
	%end;
	proc tree data=tree nclusters=&nc out=treeout noprint;
		copy &group;
	run;
	proc freq data=treeout;
		tables &group*cluster / norow nocol nopercent chisq out=freqout;
		output out=stats chisq;
	run;
	data counts;
		set freqout end=eof;
	  	by &group;
	    retain members mode;
		if first.&group then do;
			members=0; 
			mode=0;
		end;
		members=members+count;
		if count > mode then mode=count;
		if last.&group then total+(members-mode);
		if eof then output;
	run;
	data results;
		merge counts stats;
		if 0 then modify results;
		method="&method";
		misclassified=total;
		chisq=_pchi_;
		pchisq=round(p_pchi,.00001);
		cramersv=round(_cramv_,.00001);		
		output results;
	run;
%mend hierarchical;

/* define the results file structure */
data results;
	length method$ 25;			/* hierarchical method */
	length misclassified 8;		/* # misclassifications */
	length chisq 8;				/* chi square value */
	length pchisq 8;			/* chi square probability */
	length cramersv 8;			/* Cramer's V statistic */
	stop;
run;

/* range standardize the input data */
proc stdize data=sasuser.pizza method=range out=pizza;
	var &inputs;
run;

%hierarchical(dsn=pizza,method=average,nc=10)
%hierarchical(dsn=pizza,method=twostage k=9,nc=10)
%hierarchical(dsn=pizza,method=ward,nc=10)
/* additional methods */
title 'additional methods';
%hierarchical(dsn=pizza,method=centroid,nc=10)
%hierarchical(dsn=pizza,method=complete,nc=10)
%hierarchical(dsn=pizza,method=density k=4,nc=10)
%hierarchical(dsn=pizza,method=eml,nc=10)
%hierarchical(dsn=pizza,method=flexible,nc=10)
%hierarchical(dsn=pizza,method=mcquitty,nc=10)
%hierarchical(dsn=pizza,method=median,nc=10)
%hierarchical(dsn=pizza,method=single,nc=10)
title;

proc sort data=results;
	by descending cramersv misclassified;
run;

title1 'ranking of hierarchical methods';
proc print data=results noobs;
	var method cramersv misclassified;
run;

