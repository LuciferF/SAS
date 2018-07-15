/*
   Generating distances.

   The sasuser.stock data set contains the dividend yields for 15 utility stocks in the U.S. 
   The observations are names of the companies, and the variables correspond to the annual 
   dividend yields over the period 1986-1990. 
*/

%let inputs = div_1986 div_1987 div_1988 div_1989 div_1990; 

/* display the input data set */
title 'Stock Dividends';
title2 'The STOCK Data Set'; 
proc print data=sasuser.stock;
	var company &inputs;
run;

/* calculate the range standardized Euclidean distance */
proc distance data=sasuser.stock method=euclid out=dist;
	var interval(&inputs/std=range); 
    id company;
run; 

/* display the distance matrix generated */
title2 'Euclidean Distance Matrix'; 
proc print data=dist;
	id company; 
run;

ods graphics on;

/* generate hierarchical clustering solution (Ward's method)*/
proc cluster data=dist method=ward;
	id company;
run; 
 
/* ------------------------------------------------------------------------ */

/* calculate the range standardized city block distance */
proc distance data=sasuser.stock method=cityblock out=dist;
	var interval(&inputs/std=range); 
    id company; 
run; 

/* display the distance matrix generated */
title2 'City Block Distance Matrix'; 
proc print data=dist;
	id company; 
run;

/* generate hierarchical clustering solution (Ward's method)*/
proc cluster data=dist method=ward;
	id company;
run; 
 
