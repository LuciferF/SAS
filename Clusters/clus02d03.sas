/* 
	Multidimensional scaling (MDS) plots.

    This demonstration illustrates the use of multidimensional scaling as a dimension
    reduction technique for the purpose of plotting.The variable subset of the pizza 
    nutrient data suggested by the VARCLUS procedure will be used.

	Source: Johnson, D.E., 1998. Applied Multivariate Methods for Data Analysis, Duxbury  
            Press, Cole Publishing Company, Pacific Grove, CA. (Example 9.2).
*/


/* calculate range-standardized Euclidean distance */
proc distance data=sasuser.pizza method=euclid out=distances;
	var interval(carb mois sodium/std=range); 
	copy brand;
run;

/* apply multidimensional scaling */
title1 'MDS Analysis of the Pizza Nutrient Data';
proc mds data=distances level=absolute out=results(where=(_TYPE_='CONFIG')) plots=none;
	var dist:;
	id brand;	
run;

title1 'MDS Output (Partial Listing)';
proc print data=results(obs=10);
run;

/* display the MDS plot */
title1 'MDS Plot of Unlabeled Observations';
proc sgplot data=results;
	scatter y=dim2 x=dim1;
run;

/* display the MDS plot using class labeled observations */
title1 'MDS Plot of Labeled Observations';
proc sgplot data=results;
	scatter y=dim2 x=dim1/group=brand;
run;
title;
