/* 针对SASHELP.CLASS数据集，按如下要求编写程序： 
1）复制SASHELP.CLASS数据集，建立新变量BMI,其值为weight/(height*height)*1000，新数据集命名为BMIclass；
2）用proc print过程输出数据集BMIclass中NAME，SEX， AGE，BMI四个变量的观测值，其中，BMI值用FORMAT过程定义输出格式，使得变量BMI输出形式为：
BMI值<18.5 ,输出显示“偏瘦”;
18.5=<BMI值<23.9,输出显示“正常”
BMI值>=23.9，输出显示“偏胖”
3）将数据集BMIclass按性别拆分为二个名为boy、girl的新数据集，新数据集中不需有性别变量，且BMI值的输出格式为6.2，即输出显示到小数点后2位。
程序命名为classBMI02.sas*/

data BMIclass;
  set SASHELP.CLASS;
  BMI=weight/(height*height)*1000;
run;

proc format;
  value D_range low-<18.5='偏瘦'
                18.5-<23.9='正常'
                23.9-high='偏胖';
run;

proc print data=BMIclass;
  var NAME SEX AGE BMI;
  format BMI D_range.;
run;

data boy girl;
  set BMIclass;
  if sex='M' then output boy;
  if sex='F' then output girl;
run;




