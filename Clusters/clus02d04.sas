%let group  = brand;
%let inputs = carb mois sodium;

data results;
	length method$ 12;
	length misclassified 8;
	length chisq 8;
	length pchisq 8;
	length cramersv 8;
	stop;
run;

%macro standardize(dsn=, nc=, method=);

%if %bquote(%upcase(&method))=NONE %then %do;
	data temp;
		set &dsn;
	run;
%end;
%else %do;
	proc stdize data=&dsn method=&method out=temp;
		var &inputs;
	run;
%end;

proc fastclus data=temp maxc=&nc out=clusters noprint;
	var &inputs;
run;

title1 "Method: %upcase(&method)";
proc freq data=clusters;
	tables &group*cluster/norow nocol nopercent chisq out=temp;
	output chisq out=stats;
run;

data sum;
	set temp(where=(cluster NE .)) end=eof;
	by &group;
	retain members mode;
	if first.&group then do;
		members=0; 
		mode=0;
	end;
	members+count;		
	if count > mode then mode=count;
	if last.&group then	misc+(members-mode);
	if eof then output sum;
run;

data results;
	merge sum(keep=misc) stats;
	if 0 then modify results;
	method="&method";
	misclassified=misc;
	chisq=_pchi_;
	pchisq=p_pchi;
	cramersv=round(_cramv_,0.00001);
	output results;
run;

%mend standardize;

ods graphics off;

%standardize(dsn=sasuser.pizza,nc=10,method=EUCLEN);
%standardize(dsn=sasuser.pizza,nc=10,method=IQR);
%standardize(dsn=sasuser.pizza,nc=10,method=MAXABS);
%standardize(dsn=sasuser.pizza,nc=10,method=MEAN);
%standardize(dsn=sasuser.pizza,nc=10,method=MEDIAN);
%standardize(dsn=sasuser.pizza,nc=10,method=MIDRANGE);
%standardize(dsn=sasuser.pizza,nc=10,method=NONE);
%standardize(dsn=sasuser.pizza,nc=10,method=RANGE);
%standardize(dsn=sasuser.pizza,nc=10,method=STD);

ods graphics;

proc sort data=results;
	by descending cramersv misclassified;
run;

title1 'Results';
proc print data=results;
	var method cramersv misclassified ;
run;

