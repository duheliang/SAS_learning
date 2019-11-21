/* 10名幼儿园小朋友的名字、性别、生日信息，见附件表1。新建一个名为Child数据集，数据集中有四个变量
分别是name,gender,birthday,age,其中变量age是用赋值语句计算出来的每个小朋友的年龄，程序命名为
grade01.sas */

data Child;
  length Name $100;
  input Name gender $ birthday yymmdd10.;
  age=int((date()-birthday)/365.25)+1;
  format birthday yymmdd10.;
cards;
刘明铭 男 2012/11/11
李敏洁 女 2014/3/15
代子清 男 2014/9/20
夏天 男 2013/4/1
郭悦 女 2013/7/25
胡月玲 女 2013/7/20
程彬 女 2014/10/9
杨帆帆 男 2016/10/9
刘进 男 2016/5/10
张思凡 女 2015/8/19
;
run;