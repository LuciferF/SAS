data disks;
   input Technician $ Brand $ Time;
   datalines;
  Angela 1  31
  Angela 1  53
  Angela 1  41
  Angela 1  29
  Angela 1  26
  Angela 1  33
  Angela 1  47
  Angela 1  40
  Angela 2  20
  Angela 2  54
  Angela 2  40
  Angela 2  10
  Angela 2  28
  Angela 2  26
  Angela 2  41
  Angela 2  31
  Angela 3  58
  Angela 3  51
  Angela 3  52
  Angela 3  70
  Angela 3  42
  Angela 3  51
  Angela 3  32
  Angela 3  41
  Bob    1  59
  Bob    1  51
  Bob    1  78
  Bob    1  48
  Bob    1  52
  Bob    1  40
  Bob    1  73
  Bob    1  54
  Bob    2  80
  Bob    2  56
  Bob    2  60
  Bob    2  67
  Bob    2  90
  Bob    2  69
  Bob    2  89
  Bob    2  66
  Bob    3  37
  Bob    3  50
  Bob    3  43
  Bob    3  43
  Bob    3  30
  Bob    3  29
  Bob    3  45
  Bob    3  68
  Justin 1  38
  Justin 1  45
  Justin 1  46
  Justin 1  17
  Justin 1  49
  Justin 1  55
  Justin 1  61
  Justin 1  29
  Justin 2  33
  Justin 2  56
  Justin 2  33
  Justin 2  76
  Justin 2  51
  Justin 2  27
  Justin 2  39
  Justin 2  45
  Justin 3  42
  Justin 3  39
  Justin 3  58
  Justin 3  29
  Justin 3  69
  Justin 3  33
  Justin 3  41
  Justin 3  45
  Karen  1  81
  Karen  1  81
  Karen  1  83
  Karen  1  74
  Karen  1  72
  Karen  1  56
  Karen  1  72
  Karen  1  65
  Karen  2  58
  Karen  2  90
  Karen  2  54
  Karen  2  54
  Karen  2  46
  Karen  2  45
  Karen  2  35
  Karen  2  64
  Karen  3 102
  Karen  3  90
  Karen  3  84
  Karen  3  76
  Karen  3  84
  Karen  3  90
  Karen  3  94
  Karen  3  60
;
run;
proc print data=disks;
title2 'Необработанные данные';

proc means data=disks maxdec=2 n mean std;
title2 'Сводная статистика';
by Technician;
var Time;
run;

proc sort data=disks;
by Brand;

proc means data=disks maxdec=2 n mean std;
title2 'Сводная статистика';
by Brand;
var Time;

proc plot data=disks;
plot time*Technician $ Brand;
run;

proc anova data=disks;
class Brand Technician;
model Time = Brand Technician Brand*Technician;
means Technician / tukey cldiff;
means Technician /tukey lines;

proc glm data=disks;
class Brand Technician;
model Time = Brand Technician Brand*Technician;
output out=disksfit p=yhat r=resid;

proc univariate data=disksfit plot normal;
var resid;

proc plot;
plot resid*Time;
plot resid*Brand;
plot resid*Technician;
run;