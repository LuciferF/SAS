title;

/* Part 1: standardize, explore graphs. */
%let inputs = RegDens MedHHInc MeanHHSz;

proc stdize data = sasuser.census method = range out = scensus;
    var &inputs;
run;

proc surveyselect data = sasuser.census out = samplecensus method = srs n=1500 seed=123;
run;

proc sgscatter data = samplecensus;
    matrix &inputs;
run;

/* Part 2: No clear clusters; perform segmentation */
proc fastclus data = scensus maxclusters = 6 out = censusclus;
    var &inputs;
run;

data cenclus;
    /* ordering in merge statement causes original scale vars */
    /* to overwrite standardized vars */
    merge censusclus sasuser.census;

    if cluster = 3 then
        delete;
run;

proc sort data = cenclus out = sortclus;
    by cluster;
run;

proc surveyselect data = sortclus out = sampleclus 
    method = srs sampsize=(50 50 50 50 50) seed=123;
    strata cluster;
run;

proc sgscatter data = sampleclus;
    matrix &inputs / group = cluster;
run;

/* Part 3: plot the geographical clusters */
proc format;
    value grocery 1 = 'Supermarket' 2 = 'Budget' 5 = 'Boutique' 6 = 'Budget';

proc sgplot data = cenclus;
    where cluster = 1 or cluster = 2 or cluster = 5 or cluster = 6;
    format cluster grocery.;
    scatter y = locy x = locx / group = cluster;
run;