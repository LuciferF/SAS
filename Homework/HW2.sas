/* Создаем библиотеку ORION */
libname ORION '/folders/myfolders/homework#2';
/* Задание №1 */
data work.mid_q4;
set orion.order_fact;
where Order_Date between '01NOV2008'd and '14DEC2008'd;
by Order_Date notsorted;
if first.ID then Sales2Dte=0;
Sales2Dte+Total_Retail_Price;
Sales2Dte2 = Sales2Dte+Total_Retail_Price;
if first.ID then Total_Number=0;
Total_Number+Quantity;
run;
/* Задание №2.1 */
data work.sumsort;
set ORION.order_summary;
PROC SORT DATA = work.sumsort OUT = sumsort;
by Customer_ID;
run;
/* Задание №2.2 */
data work.customers;
SET ORION.ORDER_SUMMARY;
proc summary data=work.customers nway;
var  Sale_Amt;
class Customer_ID;
output out=work.customers(drop=_: )
sum=Total_Sum;
run; 
/* Задание №2.3 */
data future_expenses;
Wages=12874000;
Retire=1765000;
Medical=649000;
Income = 50000000;
start = YEAR(DATE());
stop = start+9;
do year = start to stop until (Total_Cost > Income);
wages = wages + (wages * .06); 
Retire= Retire + (Retire * .014);
Medical = (Medical + Medical * .095);
Income = (Income + Income * .01);
Total_Cost = (wages+Retire+Medical);
drop start;
drop stop;
output;
end;
/* Задание №2.4 */
data preferred_cust;
   set orion.orders_midyear;
   array Target{6} _temporary_ (200 400 300 100 100 200);
   array Mon{6} Month1-Month6;
   array Over{6} Over1-Over6;
   do i = 1 to dim(Mon);
   if Mon{i} >= Target{i} then Over{i} = Mon{i}-Target{i};
   else;
   Total_Over = sum(of Over1-Over6);
   drop i;
   end;
run;
/* Задание №2.5 */
data work.expenses; 
    Income= 50000000;  
    Expenses = 38750000;
    do Year=1 to 30 until (Expenses > Income);   
        income+(income * .01);   
        expenses+(expenses * .02);
        output;
    end;
run; 
/* Задание №2.6 */
proc sort data=orion.customer_dim out=work.customers_dim2;  
    by Customer_Type; 
run;  
data work.agecheck;
  set work.customers_dim2;
  by Customer_Type; 
  retain oldest youngest o_ID y_ID; 
  if first.Customer_Type=1 then do;
    oldest=Customer_BirthDate;
	youngest=Customer_BirthDate;
	o_ID=Customer_ID;
	y_ID=Customer_ID;
  end;
  if Customer_BirthDate < oldest then do;
    o_ID=Customer_ID;
    oldest=Customer_BirthDate;
  end;
  else if Customer_BirthDate > youngest then do;
    y_ID=Customer_ID;
    youngest=Customer_BirthDate;
  end;
  if last.Customer_Type=1 then do;
    agerange= abs(YRDIF(youngest, oldest));
	output;
  end; 
keep Customer_Type oldest youngest o_ID y_ID agerange;
proc print data=work.agecheck noobs;
format oldest youngest date9. agerange 5.1;
run;
