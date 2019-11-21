/* 1.1 */
data SITE_A;
  input Subject Sex $ Age;
datalines;
101 Male 33	
103 Female 44
;
run;

data SITE_B;
  input Subject Sex $ Age;
datalines;
201 Female 37	
202 Male 45
;
run;

/* 1.2 */
data SITE_A_B;
  set SITE_A(in=a) SITE_B(in=b);
  length SITE $10;
  if a then SITE='A';
    else if b then SITE='B';
  if age<=40 then AGEGRP=1;
    else AGEGRP=2;
run; 


data TST;
  input Subject Test $ Result $20.;
datalines;
101 TEST1 47
101 TEST2 Negative
103 TEST1 55
103 TEST2 Positive
201 TEST1 67
201 TEST2 Negative
202 TEST1 40
202 TEST2 Negative
;
run;

proc sort data=SITE_A_B out=SITE_A_B_sort;
  by Subject;
run;

proc sort data=TST out=TST_sort;
  by Subject;
run;

data ALL;
  merge SITE_A_B_sort TST_sort;
  by Subject;
run;

/* 1.4 */
proc transpose data=TST out=TST1(drop=_NAME_);
  by Subject;
  id Test;
  var Result;
run;

/* 1.5 */
proc transpose data=TST1 out=TST2(rename=(_NAME_=TEST COL1=Result));
  by Subject;
  var TEST1 TEST2;
run;

/* 1.6 */
proc print data=ALL;title 'ALL';run;
proc print data=TST1;title 'TST1';run;
proc print data=TST2;title 'TST2';run;

/* ALL to TST1_1 */
proc transpose data=ALL out=TST1_1(drop=_NAME_);
  by Subject Sex Age SITE AGEGRP;
  id Test;
  var Result;
run;
proc print data=TST1_1;title 'TST1_1';run;

/* TST1_1 to TST2_1 */
proc transpose data=TST1_1 out=TST2_1(rename=(_NAME_=TEST COL1=Result));
  by Subject Sex Age SITE AGEGRP;
  var TEST1 TEST2;
run;
proc print data=TST2_1;title 'TST2_1';run;
