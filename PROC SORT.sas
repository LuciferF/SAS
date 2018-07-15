data work.sumsort;
set ORION.order_summary;
PROC SORT DATA = work.sumsort OUT = sumsort;
by Customer_ID;
run;