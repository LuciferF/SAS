/*clus06d04.sas*/
ods graphics off;

/* assign observations to clusters. */
proc tree data = tree ncl=7 out=clus;
    copy hh5 hh10 hh11;
run;

/*visualize the clusters on 3 key variables */
ods graphics / height = 2 in width = 6.5 in;

proc sgpanel data = clus;
    panelby cluster / rows = 1 onepanel;
    histogram hh5;
run;

proc sgpanel data = clus;
    panelby cluster / rows = 1 onepanel;
    histogram hh10;
run;

proc sgpanel data = clus;
    panelby cluster / rows = 1 onepanel;
    histogram hh11;
run;

ods graphics / reset=all;

