proc reg data=ORION.TRAIN outest=ESTIM_COST tableout plots(only)=(cp) alpha=.05 ;
model ESTIM_COST = YEAR ENGINE_VOLUME FT BT TOD IT TT AC AVG_COST / selection=f;
title 'CAR ESTIMATION MODEL';
RUN;
proc score data=ORION.TESTING score=ESTIM_COST type=parms predict out=Pred;
var YEAR ENGINE_VOLUME FT BT TOD IT TT AC AVG_COST;
run;