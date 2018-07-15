proc reg data=bodyfat plots(only)=CooksD(label);
fw_final: model pctbodyfat =  Abdomen Weight Wrist Forearm;
title 'Cook D Analysis';
run;
proc reg data=bodyfat plots(only)=CooksD(label);
where Var_Num ^= 39 AND Var_Num ^= 221;
fw_final: model pctbodyfat =  Abdomen Weight Wrist Forearm;
title 'Cook D Analysis';
run;