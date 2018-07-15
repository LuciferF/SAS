/* Создание библеотеки и импорт файла */
libname ORION '/folders/myfolders/homework#1';
proc import file="/folders/myfolders/homework#1/PRICES.xlsx"
		    out=ORION.PRICES
		    DBMS=XLSX
		    REPLACE;
run;
proc print data=ORION.PRICES (obs=5); 
run;
/* Анализ увеличения стоимости по годам */
data work.price_increase; 
    set ORION.PRICES;
    Unit_Price_year1=Unit_Price * Factor; /* цена изменилась на Factor */
    Unit_Price_year2=Unit_Price_year1 * Factor; /* цена изменилась на Factor */
    Unit_Price_year3=Unit_Price_year2 * Factor; /* цена изменилась на Factor */
    output; /* выводим результаты для трех годов */
run; 
proc print data=work.price_increase (obs=6);    
    var Product_ID Unit_Price_year1 Unit_Price_year2 Unit_Price_year3; 
run; 
/* Решение №1 */
data work.admin work.Sales_Management work.Sales;
set ORION.employee_organization;
select (Department);
   when ('Sales Management') output work.Sales_Management;
   when ('Administration') output work.admin;
   when ('Engineering');
   when ('Sales') output work.Sales;
   when ('Executives');
   otherwise;
end;
run;
/* Решение №2 */
data work.admin_solution2 work.Sales_Management_solution2 work.Sales_solution2;
set ORION.employee_organization;
if Department='Administration' then output work.admin_solution2;
if Department='Sales Management' then output work.Sales_Management_solution2;
if Department='Sales' then output work.Sales_solution2;
else;
run;
/* Быстрая доставка */
data work.fast work.slow work.veryslow;
set ORION.ORDERS;
where Order_Type>1;
ShipDays=abs(Order_Date-Delivery_Date);
if Shipdays<3 then output work.fast;
if Shipdays>=5 and Shipdays<=7 then output work.slow;
if Shipdays>7  then output work.veryslow;
else;
run;
/* Страны */
data work.lookup;
set ORION.COUNTRY;
if Country_FormerName='' then;
else do;
if Country_Name^=Country_FormerName then Outdated='N';
output;
Country_Name = Country_FormerName;
end;
if Country_Name^=Country_FormerName then Outdated='N';
else Outdated='Y';
output;
proc print data=work.lookup;
run;


