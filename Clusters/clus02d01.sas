%let inputs=mois prot fat ash sodium carb cal;

title1 'Pizza Nutrient Analysis';
proc varclus data=sasuser.pizza maxeigen=0.7;
	var &inputs;
run;

