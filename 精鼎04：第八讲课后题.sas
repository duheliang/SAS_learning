data adae;
length usubjid saffl trt01a aebodsys aedecod $200;
usubjid='970'; saffl='Y'; trt01a='DRUG A'; aebodsys='Blood and lymphatic system disorders'; aedecod='Anaemia';  output;
usubjid='259'; saffl='Y'; trt01a='DRUG B'; aebodsys='Blood and lymphatic system disorders'; aedecod='Anaemia macrocytic';  output;
usubjid='921'; saffl='Y'; trt01a='DRUG A'; aebodsys='Blood and lymphatic system disorders'; aedecod='Anaemia macrocytic';  output;
usubjid='542'; saffl='Y'; trt01a='DRUG A'; aebodsys='Cardiac disorders'; aedecod='Angina pectoris';  output;
usubjid='531'; saffl='Y'; trt01a='DRUG A'; aebodsys='Cardiac disorders'; aedecod='Angina pectoris';  output;
usubjid='49'; saffl='Y'; trt01a='DRUG B'; aebodsys='Cardiac disorders'; aedecod='Angina pectoris';  output;
usubjid='66'; saffl='Y'; trt01a='DRUG B'; aebodsys='Cardiac disorders'; aedecod='Angina pectoris';  output;
usubjid='523'; saffl='Y'; trt01a='DRUG A'; aebodsys='Cardiac disorders'; aedecod='Angina unstable';  output;
usubjid='853'; saffl='Y'; trt01a='DRUG A'; aebodsys='Cardiac disorders'; aedecod='Angina unstable';  output;
usubjid='67'; saffl='Y'; trt01a='DRUG B'; aebodsys='Cardiac disorders'; aedecod='Angina unstable';  output;
usubjid='297'; saffl='Y'; trt01a='DRUG B'; aebodsys='Cardiac disorders'; aedecod='Cardiac failure acute';  output;
usubjid='272'; saffl='Y'; trt01a='DRUG B'; aebodsys='Cardiac disorders'; aedecod='Cardiac failure acute';  output;
usubjid='689'; saffl='Y'; trt01a='DRUG A'; aebodsys='Cardiac disorders'; aedecod='Cardiac failure acute';  output;
usubjid='976'; saffl='Y'; trt01a='DRUG A'; aebodsys='Cardiac disorders'; aedecod='Cardiac failure acute';  output;
usubjid='688'; saffl='Y'; trt01a='DRUG A'; aebodsys='Eye disorders'; aedecod='Visual acuity reduced';  output;
usubjid='558'; saffl='Y'; trt01a='DRUG A'; aebodsys='General disorders and administration site conditions'; aedecod='Injection site bruising';  output;
usubjid='287'; saffl='Y'; trt01a='DRUG B'; aebodsys='General disorders and administration site conditions'; aedecod='Injection site bruising';  output;
usubjid='634'; saffl='Y'; trt01a='DRUG A'; aebodsys='Infections and infestations'; aedecod='Onychomycosis';  output;
usubjid='634'; saffl='Y'; trt01a='DRUG A'; aebodsys='Infections and infestations'; aedecod='Onychomycosis';  output;
usubjid='582'; saffl='Y'; trt01a='DRUG A'; aebodsys='Injury, poisoning and procedural complications'; aedecod='Lumbar vertebral fracture';  output;
usubjid='377'; saffl='Y'; trt01a='DRUG B'; aebodsys='Injury, poisoning and procedural complications'; aedecod='Lumbar vertebral fracture';  output;
usubjid='506'; saffl='Y'; trt01a='DRUG A'; aebodsys='Metabolism and nutrition disorders'; aedecod='Decreased appetite';  output;
usubjid='931'; saffl='Y'; trt01a='DRUG A'; aebodsys='Metabolism and nutrition disorders'; aedecod='Decreased appetite';  output;
usubjid='929'; saffl='Y'; trt01a='DRUG A'; aebodsys='Metabolism and nutrition disorders'; aedecod='Decreased appetite';  output;
usubjid='297'; saffl='Y'; trt01a='DRUG B'; aebodsys='Neoplasms benign, malignant and unspecified (incl cysts and polyps)'; aedecod='Rectal adenocarcinoma';  output;
usubjid='391'; saffl='Y'; trt01a='DRUG B'; aebodsys='Neoplasms benign, malignant and unspecified (incl cysts and polyps)'; aedecod='Rectal adenocarcinoma';  output;
usubjid='679'; saffl='Y'; trt01a='DRUG A'; aebodsys='Respiratory, thoracic and mediastinal disorders'; aedecod='Haemoptysis';  output;
usubjid='168'; saffl='Y'; trt01a='DRUG B'; aebodsys='Respiratory, thoracic and mediastinal disorders'; aedecod='Haemoptysis';  output;
usubjid='871'; saffl='Y'; trt01a='DRUG A'; aebodsys='Respiratory, thoracic and mediastinal disorders'; aedecod='Interstitial lung disease';  output;
usubjid='934'; saffl='Y'; trt01a='DRUG A'; aebodsys='Respiratory, thoracic and mediastinal disorders'; aedecod='Laryngeal discomfort';  output;
usubjid='568'; saffl='Y'; trt01a='DRUG A'; aebodsys='Skin and subcutaneous tissue disorders'; aedecod='Swelling face';  output;
usubjid='49'; saffl='Y'; trt01a='DRUG B'; aebodsys='Skin and subcutaneous tissue disorders'; aedecod='Swelling face';  output;
usubjid='135'; saffl='Y'; trt01a='DRUG B'; aebodsys='Skin and subcutaneous tissue disorders'; aedecod='Swelling face';  output;
usubjid='511'; saffl='Y'; trt01a='DRUG A'; aebodsys='Skin and subcutaneous tissue disorders'; aedecod='Swelling face';  output;

run;


/************************** count event(N) **************************/

proc sort data=adae (where=(saffl='Y')) out=adae1;
  by trt01a aebodsys aedecod;
run;

data socn;                     *count aebodsys using retain statement;
  set adae1(drop=usubjid saffl aedecod);
    by trt01a aebodsys;
    retain soc_seq 0;
    if first.aebodsys then
      soc_seq=1;
    else
      soc_seq=soc_seq+1;
  if last.aebodsys;
run;

data ptn;                       *count aedecod using retain statement;
  set adae1(drop=usubjid saffl);
    by trt01a aebodsys aedecod;
    retain pt_seq 0;
    if first.aedecod then
      pt_seq=1;
    else
      pt_seq=pt_seq+1;
  if last.aedecod;
run;

data ptn1;
  merge socn ptn;
    by trt01a aebodsys;
run;

data all1;                              **  important  **;
  set socn(in=a) ptn1;
    if a then socptn=0;
	else socptn=1;
  length item $200;
    if a then item=aebodsys;
	else item='  '||aedecod;
	if a then bign=soc_seq;
	else bign=pt_seq;
run;

proc sort data=all1 out=all2(keep=trt01a item bign);
  by trt01a descending soc_seq aebodsys socptn descending pt_seq aedecod;
run;

data all3;
  set all2;
    obs=_n_;
run;


/************************** count event(n) **************************/

proc sort data=adae(where=(saffl='Y')) out=adae2 nodupkey;
  by trt01a aebodsys usubjid;
run;

proc sort data=adae(where=(saffl='Y')) out=adae3 nodupkey;
  by trt01a aebodsys aedecod usubjid;
run;

data socn1;
  set adae2(drop=usubjid saffl aedecod);
    by trt01a aebodsys;
    retain soc_seq 0;
    if first.aebodsys then
      soc_seq=1;
    else
      soc_seq=soc_seq+1;
  if last.aebodsys;
run;

data ptn1;
  set adae3(drop=usubjid saffl);
    by trt01a aebodsys aedecod;
    retain pt_seq 0;
    if first.aedecod then
      pt_seq=1;
    else
      pt_seq=pt_seq+1;
  if last.aedecod;
run;

data ptn2;
  merge socn1 ptn1;
    by trt01a aebodsys;
run;

data alln1;
  set socn1(in=a) ptn2;
    if a then socptn=0;
	else socptn=1;
  length item $200;
    if a then item=aebodsys;
	else item='  '||aedecod;
	if a then smalln=soc_seq;
	else smalln=pt_seq;
run;

proc sort data=alln1 out=alln2(keep=trt01a item smalln);
  by trt01a descending soc_seq aebodsys socptn descending pt_seq aedecod;
run;


/********************** combine bign and smalln **********************/

proc sort data=all3 out=all4;
  by trt01a item;
run;

proc sort data=alln2 out=alln3;
  by trt01a item;
run;

data all;
  merge all4 alln3;
    by trt01a item;
  length col $200;
    col=strip(put(bign,best.))||'#'||strip(put(smalln,best.));
run;

proc sort data=all out=final(keep=trt01a item col);
  by obs;
run;
