/*clus06d02.sas*/
proc sgscatter data = sasuser.hhsurvey;
    matrix hh5 hh10 hh11;
run;

/* plots not useful because of 5-point scale. PC plots of all variables might be better. */
proc princomp data = sasuser.hhsurvey n=3 plots(only)=matrix;
    var hh:;
run;

