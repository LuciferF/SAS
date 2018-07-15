/*clus05d03.sas*/
/*
Combined strategy (hierarchical Ward's and k-means).

Pre-cluster with FASTCLUS and use the hierarchical clustering CCC recomended 
number of clusters to set the number of seeds for kmeans clustering. This 
approach is most appropriate for finding roughly spherical clusters defined 
by a mean vector (centroid)

Note: This is similar to the approach used in SAS Enterprise Miner's 
CLUSTERING node and is best suited for data sets with too many
observations for hierarchical clustering to be practical.
*/

%let inputs=weight3 height width length logRatio; /* input variables */

/* range standardize input variables */
proc stdize data=sasuser.fish method=range outstat=stats out=sfish;
    var &inputs;
run;

/* 1. Pre-cluster with PROC FASTCLUS. For this small example, 50 preliminary 
 clusters are specified. For a larger data set, 100 or more clusters is preferable. */
proc fastclus data = sfish maxc = 50 outseed = preclus noprint;
    var &inputs;
run;

/* 2. Generate the clustering history and associated CCC values */
title1 'Hierarchical Clustering';

ods output CccPsfAndPsTSqPlot=plotdata;
proc cluster data=preclus 
             notie
             method = ward 
             plots = (pseudo 
                      ccc 
                      dendrogram(vertical sw=6.5 unit=in));
    var &inputs;
run;

/* sort by the number of clusters */
proc sort data=plotdata out=plot_sorted;
    by numberofclusters;
run;

/* determine the best number of clusters based on CCC, PSF, PST2 */
/* each data set contains candidate number of clusters for a criterion */
data plotdataccc(keep=nclusters lag1_ccc)
    plotdatapsf(keep=nclusters lag1_psf) 
    plotdatapst2(keep=nclusters lag1_pst2);
    set plot_sorted;
    nclusters=lag1(NumberOfClusters);
    lag1_ccc=lag1(CubicClusCrit);
    lag2_ccc=lag2(CubicClusCrit);

    if lag1_ccc > 2 and lag1_ccc > CubicClusCrit and 
        lag1_ccc > lag2_ccc then
        do;
            output plotdataccc;
        end;

    lag1_psf=lag1(PseudoF);
    lag2_psf=lag2(PseudoF);

    if lag1_psf > PseudoF and lag1_psf > lag2_psf then
        do;
            output plotdatapsf;
        end;

    lag1_pst2=lag1(PseudoTSq);
    lag2_pst2=lag2(PseudoTSq);

    if lag1_pst2 > . and lag1_pst2 < PseudoTSq and 
        lag1_pst2 <= lag2_pst2 then
        do;
            output plotdatapst2;
        end;
run;

/* Merge candidates with original data set for graphing */
data plotdata2;
    merge plot_sorted 
        plotdataccc(rename=(nclusters=NumberOfClusters lag1_ccc=CubicClusCrit) in=ccc)
        plotdatapsf(rename=(nclusters=NumberOfClusters lag1_psf=PseudoF ) in=psf)
        plotdatapst2(rename=(nclusters=NumberOfClusters lag1_pst2=PseudoTSq) in=pst2);
    by NumberOfClusters;

    if ccc then
        ccc_cand=NumberOfClusters;

    if psf then
        psf_cand=NumberOfClusters;

    if pst2 then
        pst2_cand=NumberOfClusters;
run;

proc sgplot data=plotdata2;
    series x=NumberOfClusters
        y=CubicClusCrit/  markers datalabel=ccc_cand;
    series x=NumberOfClusters
        y=PseudoF / markers datalabel=psf_cand;
    series x=NumberOfClusters
        y=PseudoTSq / markers datalabel=pst2_cand;
    yaxis label = 'Value';
    title 'Plot of CCC, PSF, and PST2';
run;

/* 3. Apply k-means using the above recommended number of clusters */
title1 'K-Means Clustering using Adaptive Training';

proc fastclus data=sfish maxclusters=7 drift maxiter=20 out=results;
    var &inputs;
run;

/* store the orginal observation number */
data results;
    set results;
    idnum = _n_;
run;

/* sort by distance within cluster */
proc sort data=results;
    by cluster distance;
run;

/* un-standardize the input variables */
proc stdize data=results method=in(stats) unstdize out=results;
    var &inputs;
run;

/* output the k-means solution */
title1 'Results (Partial Listing)';

proc print data=results(obs=20);
    var idnum &inputs cluster distance;
run;

title1 'Box-and-Whisker Plot';

proc sgplot data=results;
    vbox distance/category=cluster;
run;


