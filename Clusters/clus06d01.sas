/*clus06d01.sas*/
ods graphics;
title;

proc varclus data = sasuser.hhsurvey outtree=tree;
    var hh:;
run;

