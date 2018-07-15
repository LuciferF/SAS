/*clus06d05.sas*/
/* Score full database. */
proc discrim data = hhclus testdata = sasuser.hhcatalog 
    testout = scorediscrim;
    class cluster;
    priors prop;
    var &inputs;
run;

proc contents data = scorediscrim position;
run;

