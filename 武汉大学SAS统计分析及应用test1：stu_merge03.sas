/* 用程序stu_merge03.sas实现: */
/* 1）参见附件，创建数据集stu_info和stu_score，且合并生成新数据集student. */
/* 2） 输出显示数据集student中的id,subject,score,class列,并分别以标签”学号”,”科目”,”分数"和”班级"显示。 */

data stu_info;
  input ID SEX $ AGE CLASS $;
cards;
1 boy 14 A
2 girl 15 A
3 girl 15 A
4 boy 16 B
5 boy 15 B
6 girl 15 B
;
run;

data stu_score;
  input ID SUBJECT $ SCORE;
cards;
1 Chinese 89
1 maths 79
2 Chinese 67
2 maths 84
3 Chinese 78
3 maths 83
4 Chinese 69
4 maths 85
5 Chinese 79
5 maths 69
;
run;

data student;
  merge stu_info stu_score;
  by ID;
run;

proc print label;
  var ID SUBJECT SCORE CLASS;
  label ID='学号'
        SUBJECT='科目'
        SCORE='分数'
        CLASS='班级';
run;