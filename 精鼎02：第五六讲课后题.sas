Data DM1;
  Input subject 2. +1 age 2.  +1 sex $1. +1 firstdt yymmdd10.;
  FORMAT firstdt yymmdd10.;
  Datalines;
 6 25 F 2016-08-12
 3 18 M 2016-08-18
10 30 F 2016-08-28
12 38 M 2016-08-17
;
Run;

DATA VS;
 INPUT SUBJECT 2. +1 VISIT $2. +1 TEST $6. +1 VISITDT DATE9. +1 VALUE 4.1;
 FORMAT VISITDT DATE9.;
 DATALINES;
 3 V1 WEIGHT 10AUG2016 78.0
 3 V2 WEIGHT 13AUG2016 79.5
 3 V3 WEIGHT 16AUG2016 79.0
 3 V4 WEIGHT 19AUG2016 .
 3 V5 WEIGHT 22AUG2016 76.3
 3 V6 WEIGHT 25AUG2016 76.1
 3 V7 WEIGHT 28AUG2016 76.0
 3 V8 WEIGHT 31AUG2016 73.2
 3 V9 WEIGHT 02SEP2016 .
 6 V1 WEIGHT 06AUG2016 65.0
 6 V2 WEIGHT 09AUG2016 63.5
 6 V3 WEIGHT 12AUG2016 62.0
 6 V4 WEIGHT 15AUG2016 60.0
 6 V5 WEIGHT 18AUG2016 .
 6 V6 WEIGHT 21AUG2016 57.0
 6 V7 WEIGHT 24AUG2016 55.0
 6 V8 WEIGHT 27AUG2016 .
 6 V9 WEIGHT 30AUG2016 .
10 V1 WEIGHT 19AUG2016 .
10 V2 WEIGHT 23AUG2016 87.0
10 V3 WEIGHT 26AUG2016 86.0
10 V4 WEIGHT 29AUG2016 84.0
10 V5 WEIGHT 02SEP2016 84.5
10 V6 WEIGHT 05SEP2016 .
10 V7 WEIGHT 08SEP2016 82.0
10 V8 WEIGHT 11SEP2016 75.7
10 V9 WEIGHT 14SEP2016 75.0
;
RUN;

/* 要求
将每次访视缺失值用LOCF法进行填补，计算每次访视与基线的差值chg，将每位受试者第一次访视的chg置空，并按如下标准进行分类：
chg	     chgcat
<=-5	 Very good
-5<-<=0	 good
0<-<=5	 invalid
>5	     worse */


/* LOCF填补 */
data VS1;
  set VS;
  by subject visit;
  retain newvalue;
  if first.subject then newvalue=.;
  if value^=. then newvalue=value;
  drop value;
  rename newvalue=value;
run;

/* 确定基线 */
proc sort data=DM1 out=DM2;
  by subject;
run;

proc sort data=VS1 out=VS2;
  by subject visit;
run;

data VS3;              *给药前访视观;
  merge DM2 VS2;
  by subject;
  if visitdt<firstdt and value^=.;
run;

data baseline;         *确定基线;
  set VS3;
  by subject visit;
  if last.subject;
  keep subject value;
  rename value=value_base;
Run;

/* 将基线merge回去，计算差值并分类 */
data VS4;
  merge VS2 baseline;
  by subject;
run;

data VS5;
  set VS4;
  chg=value-value_base; 
  if visit='V1' then chg='';
  length chgcat $ 9;
/*   if value=. then chgcat='Missing'; */
  else if .<chg<=-5 then chgcat='Very good';
  else if -5<chg<=0 then chgcat='good';
  else if 0<chg<=5 then chgcat='invalid';
  else chgcat='worse';
run;

proc print;run;

