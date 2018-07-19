data one;
input id ChildsNumber $char15.;
datalines;
1 1-3
2 1-3
3 1-3
4 More than 3
5 No Children
6 More than 3
7 No Children
8 More than 3
9 No Children
10 1-3
11 1-3
;
data variant_1;
set one;
if ChildsNumber = '1-3' then OneTwoThree = '1';
else OneTwoThree = '0';
if ChildsNumber = 'No Children' then No_Children = '1';
else No_Children = '0';
if ChildsNumber = 'More than 3' then More_than_3 = '1';
else More_than_3 = '0';
data variant_2;
set one;
OneTwoThree=(ChildsNumber='1-3');
More_than_3=(ChildsNumber='More than 3');
No_Children=(ChildsNumber='No Children');
Array a {3} OneTwoThree More_than_3 No_Children;
	do i = 1 to 3;
	If ChildsNumber=" " then a(i) = " ";
	end;
run;
