%let inputs = carb mois sodium;

title 'PCA of Pizza Nutrient Data';
proc princomp data=sasuser.pizza out=pizza;
	var &inputs;
run;

title2 'PCA Output (Partial Listing)';
proc print data=pizza(obs=10);
run;

title2 'Plot of Unlabeled Observations';
proc sgplot data=pizza;
	scatter y=prin2 x=prin1;
run;

title2 'Plot with Labeled Observations';
proc sgplot data=pizza;
	scatter y=prin2 x=prin1/group=brand;
run;
