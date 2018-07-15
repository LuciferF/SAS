proc corr data=BodyFat rank
     plots(only)=scatter(nvar=all alpha=.30);
     ods output PearsonCorr=P1;
var age weight height FatFreeWt Adioposity;
with pctbodyfat;
id Var_Num;
title 'Body Fat Correlations';
run;