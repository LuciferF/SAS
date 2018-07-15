libname ORION '/folders/myfolders/homework#4';
data work.correctdata;
set ORION.EMPLOYEE_DONATIONS;
if Qtr1 ='.' then Qtr1 = 0;
else;
if Qtr2 ='.' then Qtr2 = 0;
else;
if Qtr3 ='.' then Qtr3 = 0;
else;
if Qtr4 ='.' then Qtr4 = 0;
else;
run;
proc sql;
select Employee_ID, Employee_Gender, Marital_Status
from ORION.EMPLOYEE_PAYROLL as B
where exists (select * 
from work.correctdata
where Employee_Payroll.Employee_ID=
correctdata.Employee_ID
and (Qtr1+Qtr2+Qtr3+Qtr4)/Salary > 0.0002)
order by Employee_ID;
run;
proc sql;
select Customer_Name, Count(*) as Count
from orion.Product_Dim as A,
orion.Order_Fact as B,
orion.Customer as C
where A.Product_ID=B.Product_ID
and B.Customer_ID=C.Customer_ID
and Employee_ID=99999999
and A.Supplier_Country ne Country
and Country in ('US','AU')
group by Customer_Name
order by Count desc, Customer_Name
;
quit;