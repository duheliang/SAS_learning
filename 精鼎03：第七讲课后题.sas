data ADSL;
USUBJID='1001'; FASFL='Y'; AGE=55; AGEGR1='20 - 64 years'; WEIGHT=50.4; SEX='F'; HEIGHT=177; RACE='ASIAN'; TRT01P='DRUG A';  output;
USUBJID='1002'; FASFL='Y'; AGE=60; AGEGR1='20 - 64 years'; WEIGHT=54.6; SEX='F'; HEIGHT=168; RACE='BLACK OR AFRICAN AMERICAN'; TRT01P='DRUG B';  output;
USUBJID='1003'; FASFL='Y'; AGE=18; AGEGR1='   - 19 years'; WEIGHT=67.9; SEX='F'; HEIGHT=154; RACE='WHITE'; TRT01P='DRUG B';  output;
USUBJID='1004'; FASFL='Y'; AGE=37; AGEGR1='20 - 64 years'; WEIGHT=41.5; SEX='M'; HEIGHT=144; RACE='ASIAN'; TRT01P='DRUG A';  output;
USUBJID='1005'; FASFL='Y'; AGE=58; AGEGR1='20 - 64 years'; WEIGHT=54.9; SEX='F'; HEIGHT=166; RACE='ASIAN'; TRT01P='DRUG B';  output;
USUBJID='1006'; FASFL='N'; AGE=55; AGEGR1='20 - 64 years'; WEIGHT=60; SEX='F'; HEIGHT=153; RACE='WHITE'; TRT01P='DRUG B';  output;
USUBJID='1007'; FASFL='Y'; AGE=60; AGEGR1='20 - 64 years'; WEIGHT=49.6; SEX='F'; HEIGHT=166; RACE='ASIAN'; TRT01P='DRUG A';  output;
USUBJID='1008'; FASFL='Y'; AGE=55; AGEGR1='20 - 64 years'; WEIGHT=76.7; SEX='F'; HEIGHT=170; RACE='BLACK OR AFRICAN AMERICAN'; TRT01P='DRUG A';  output;
USUBJID='1009'; FASFL='Y'; AGE=38; AGEGR1='20 - 64 years'; WEIGHT=65.6; SEX='M'; HEIGHT=181; RACE='WHITE'; TRT01P='DRUG B';  output;
USUBJID='1010'; FASFL='Y'; AGE=35; AGEGR1='20 - 64 years'; WEIGHT=60; SEX='M'; HEIGHT=185; RACE='BLACK OR AFRICAN AMERICAN'; TRT01P='DRUG A';  output;
USUBJID='1011'; FASFL='Y'; AGE=51; AGEGR1='20 - 64 years'; WEIGHT=46.6; SEX='F'; HEIGHT=167; RACE='ASIAN'; TRT01P='DRUG B';  output;
USUBJID='1012'; FASFL='Y'; AGE=58; AGEGR1='20 - 64 years'; WEIGHT=72.1; SEX='F'; HEIGHT=159; RACE='BLACK OR AFRICAN AMERICAN'; TRT01P='DRUG A';  output;
USUBJID='1013'; FASFL='Y'; AGE=78; AGEGR1='76 -    years'; WEIGHT=51.2; SEX='M'; HEIGHT=188; RACE='ASIAN'; TRT01P='DRUG B';  output;
USUBJID='1014'; FASFL='Y'; AGE=47; AGEGR1='20 - 64 years'; WEIGHT=74.2; SEX='M'; HEIGHT=171; RACE='WHITE'; TRT01P='DRUG A';  output;
USUBJID='1015'; FASFL='Y'; AGE=22; AGEGR1='20 - 64 years'; WEIGHT=65; SEX='F'; HEIGHT=156; RACE='ASIAN'; TRT01P='DRUG B';  output;
USUBJID='1016'; FASFL='Y'; AGE=29; AGEGR1='20 - 64 years'; WEIGHT=60.8; SEX='M'; HEIGHT=176; RACE='BLACK OR AFRICAN AMERICAN'; TRT01P='DRUG A';  output;
USUBJID='1017'; FASFL='N'; AGE=60; AGEGR1='20 - 64 years'; WEIGHT=50.1; SEX='M'; HEIGHT=168; RACE='ASIAN'; TRT01P='DRUG B';  output;
USUBJID='1018'; FASFL='Y'; AGE=55; AGEGR1='20 - 64 years'; WEIGHT=49.7; SEX='F'; HEIGHT=166; RACE='ASIAN'; TRT01P='DRUG B';  output;
USUBJID='1019'; FASFL='Y'; AGE=73; AGEGR1='65 - 75 years'; WEIGHT=54; SEX='F'; HEIGHT=161; RACE='WHITE'; TRT01P='DRUG B';  output;
USUBJID='1020'; FASFL='Y'; AGE=68; AGEGR1='65 - 75 years'; WEIGHT=60.1; SEX='F'; HEIGHT=170; RACE='ASIAN'; TRT01P='DRUG B';  output;
run;

/* Analysis var of HEIGHT */
proc means data=adsl(where=(fasfl='Y')) nway;
  class trt01p;
  var height;
  output out=height_means(drop=_type_ _freq_)
    n=_n mean=_mean std=_sd stderr=_se min=_minimum q1=_q1 median=_median q3=_q3 max=_maximum;
run;

data height_means1;
  set height_means;
  length N Mean SD SE Minimum q1 Median q3 Maximum $100;
  n=put(_n,3.);
  mean=put(_mean,5.1);
  sd=put(_sd,6.2);
  se=put(_se,6.2);
  minimum=put(_minimum,3.);
  q1=put(_q1,5.1);
  median=put(_median,5.1);
  q3=put(_q3,5.1);
  maximum=put(_maximum,3.);
  drop _:;
run;

proc transpose data=height_means1 out=height_means2;
  id trt01p;
  var N Mean SD SE Minimum q1 Median q3 Maximum;
run;

data height_means3;
  length DEMO $100;
  set height_means2;
  if _name_='q1' then demo='25%';
  else if _name_='q3' then demo='75%';
  else demo=_name_;
  drop _name_;
run;

/* Analysis var of RACE */
proc freq data=adsl(where=(Fasfl='Y'));
  tables trt01p/out=race_n;
run;

proc sort data=adsl(where=(Fasfl='Y')) out=adsl1;
  by trt01p;
run;

proc freq data=adsl1;
  by trt01p;
  tables race/out=race_n1;
run;

data race_n2;
  merge race_n1(drop=percent) race_n(drop=percent rename=(count=n));
  by trt01p;
run;

data race_n3;
  set race_n2;
  length num $100;
  num=put(count,3.)  ||  ' ('  ||  put(count/n*100,4.1)  ||  '%)';
  keep trt01p race num;
run;

proc sort data=race_n3 out=race_n4;
  by race;
run;

proc transpose data=race_n4 out=race_n5;
  by race;
  id trt01p;
  var num;
run;

data race_n6;
  set race_n5;
  if missing(drug_a) then drug_a='  0';
  if missing(drug_b) then drug_b='  0';
  drop _name_;
run;
