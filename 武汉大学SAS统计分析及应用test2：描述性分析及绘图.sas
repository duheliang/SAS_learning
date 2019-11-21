/*test1*/
data test_score;
  input score @@;
datalines;
60	91	90	73	80	81	58	68	90	89	72	89	91	92	91	89	96	92
91	95	94	93	94	77	55	87	82	74	76	88	53	82	94	87	90	95
68	82	80	86	92	92	86	82	89	91	93	86	84	90	93	78	77	73
90	60	92	83	81	84	83	93	91	84	89	97	72	94	75	72	90	93
;
run;

proc means data=test_score
  mean median max min q1 q3 maxdec=2;
run;

proc sgplot data=test_score;
  histogram score/binstart=10 binwidth=10 showbins scale=count;
run;

/*test2*/
data fami30;
  input familyID areaID income outgo;
datalines;
1	2	1794	1550
2	2	1716	1365
3	1	3410	2730
4	2	1765	1530
5	2	2184	1900
6	2	2050	2050
7	2	2460	2184
8	1	1976	1170
9	1	2850	2496
10	1	4275	2760
11	2	2010	1275
12	1	2236	1810
13	1	3305	2820
14	1	2400	1976
15	2	2250	1970
16	2	2200	2060
17	1	2730	2236
18	1	2496	1455
19	1	1760	1040
20	1	2820	2366
21	2	2250	1966
22	1	3170	2400
23	2	1200	1250
24	2	1776	1350
25	2	1980	1794
26	1	2455	2550
27	2	1080	1380
28	2	1986	1200
29	1	3369	2305
30	2	1530	1316
;
run;

proc sgplot data=fami30;
  vbox income/category=areaID;
run;

proc gchart data=fami30;
  block income/subgroup=areaID;
run;

/*test3*/
data kiddeath;
  input month braindeath huxideath@@;
cards;
1 2.6 7.4 2 7.4 7.4 3 6.5 14.5 4 8.7 4.2
5 13.4 8.9 6 14.2 7.6 7 11.7 10.4 8 10.4 8.7
9 5.2 10.8 10 6.5 5.2 11 5.6 5.8 12 7.8 6.2
;
run;

proc gplot data=kiddeath;
  plot braindeath*month huxideath*month/overlay;
  symbol1 v=plus c=red i=join;
  symbol2 v=star c=blue i=join;
run;

/*test4*/
data twolines;
  do x=-4 to 6;
    y1=x*x-2*x+1; 
    y2=3*x+4;
    output;
  end;
run; 

proc gplot data=twolines;
  plot y1*x y2*x/overlay;
  symbol1 v=plus c=red i=spline;
  symbol2 v=star c=blue i=join;
run;
