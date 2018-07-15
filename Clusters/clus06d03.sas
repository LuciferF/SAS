/*clus06d03.sas*/
ods output CccPsfAndPsTSqPlot=plotdata;
ods exclude CccPsfAndPsTSqPlot;

proc cluster data = sasuser.hhsurvey 
             outtree = tree 
             notie
             method = ward 
             plots = (pseudo 
                      ccc 
                      dendrogram(vertical sw=6.5 unit=in));
    var hh5 hh10 hh11;
run;

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

    if lag1_ccc > 2 and lag1_ccc > CubicClusCrit 
        and lag1_ccc > lag2_ccc then
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

    if lag1_pst2 > . and lag1_pst2 < PseudoTSq 
        and lag1_pst2 <= lag2_pst2 then
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

title 'Plot of CCC, PSF, and PST2';

proc sgplot data=plotdata2;
    series x=NumberOfClusters
        y=CubicClusCrit/  markers datalabel=ccc_cand;
    series x=NumberOfClusters
        y=PseudoF / markers datalabel=psf_cand;
    series x=NumberOfClusters
        y=PseudoTSq / markers datalabel=pst2_cand;
    yaxis label = 'Value';
run;

title;

