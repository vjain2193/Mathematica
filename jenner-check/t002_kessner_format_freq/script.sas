/*****************************************************
PURPOSE: To do the descriptive analysis for generation 1, 1979-1983
We will do this analysis by race, preterm category and education
Adapted from Chap1_g1_overall_raceethn_edu.sas for the Jenner compatibility
bundle: the original LIBNAME DT/VA pointed at the author's private
dissertation data; here CHAP_SRC is a small inline mock cohort carrying
the columns the DATA step reads (SAM_combgest_final, M_HISP, M_RACE,
SAM_AGEMOM, SAM_EDUMOM, SAM_EDUDAD, SAM_MARITAL, SAM_PNC, SAM_PNCVST_TOTAL).
The PROC FORMAT value-label sets, the maternal-age/education recoding, the
Kessner Index of adequacy of prenatal care computation, and the PROC FREQ
tables below are the author's own logic, unchanged. (RACEHISP is reported
with $RACEETH., the one race-label format actually defined in this file's
PROC FORMAT block -- the original also referenced an undefined fmrace.
format on these same TABLES statements, which we don't carry forward.)
******************************************************/

PROC FORMAT;
  value fy1n0x   	0="No"
					1="Yes";
  value fpresabs 	0="Absent"
					1="Present";
  value fPTBRE 		0="Early Preterm: 20-32"
			 	   		1="Late Preterm: 33-37"
				   		2="Term: 38-47" ;
  value fmage6x     1="<20 yrs"
					2="20-<25 yrs"
					3="25-<30 yrs"
					4="30-<35 yrs"
					5="35-55 yrs"
					6 = "Missing";
  value feduc6x 	1="0-8 yrs"
					2="9-11 yrs"
					3="12 yrs"
               		4="13-15 yrs"
					5="16+ yrs"
					6="unknown";
  value fmeduc3x 	1="< HS"
					2="HS"
					3="> HS"
					4="Missing";
  value $fadeq  	1="adequate"
					2="intermediate"
               		3="inadequate"
					4="Unknown";
  value $gender		1="Male"
  					2="Female";
  value $RACEETH  	0="White NH"
					1="Black NH"
               		2="Hispanic"
					3="Others";
RUN;

data CHAP_SRC;
  input SAM_combgest_final M_HISP M_RACE SAM_AGEMOM SAM_EDUMOM SAM_EDUDAD SAM_MARITAL SAM_PNC SAM_PNCVST_TOTAL;
  datalines;
39 0 1 24 12 12 1 10 8
27 0 2 19 9  10 2 3  0
41 1 3 32 16 16 1 12 9
36 0 1 28 13 14 1 8  6
30 0 2 21 11 11 2 4  1
38 2 4 26 8  9  1 9  7
33 0 1 34 15 16 1 11 8
40 0 2 23 12 12 1 10 9
25 3 5 18 6  7  2 2  0
39 0 1 30 14 14 1 9  8
;
run;

DATA livefnh1;
	SET CHAP_SRC;

	IF M_HISP EQ 0 AND M_RACE EQ 1 THEN RACEHISP = 0; /*NH WHITE*/
	ELSE IF M_HISP EQ 0 AND M_RACE EQ 2 THEN RACEHISP = 1; /*NH BLLACK*/
	ELSE IF M_HISP IN (1,2,3,4,5) THEN RACEHISP = 2; /*Hispanic*/
	ELSE RACEHISP = 3;

	/*extremely preterm (<28 weeks)
very preterm (28 to <32 weeks)
moderate to late preterm (32 to <37 weeks).*/

	IF 20 < SAM_combgest_final <37 THEN SAM_PTB4 = 1;
	ELSE IF 37 <= SAM_combgest_final <=47 THEN SAM_PTB4 = 0;

 /*Just to create PTB and non-PTB*/
	IF 20 < SAM_combgest_final < 38 THEN PTB_CAT1 = 1;
	ELSE IF 38 <= SAM_combgest_final <=47 THEN PTB_CAT1 = 0;


/* recode maternal age */
SAM_MAGE3 = .;
  if '12' <= SAM_AGEMOM < '20' then SAM_MAGE = 1;
  else if '20' <= SAM_AGEMOM < '25' then SAM_MAGE = 2;
  else if '25' <= SAM_AGEMOM < '30' then SAM_MAGE = 3;
  else if '30' <= SAM_AGEMOM < '35' then SAM_MAGE = 4;
  else if '35' <= SAM_AGEMOM < '55' then SAM_MAGE = 5;
  else SAM_MAGE = 6;



/* recode maternal education */
SAM_meduc3 = .;
  IF '0' <= SAM_EDUMOM < '12' THEN SAM_meduc = 1;
  else if SAM_EDUMOM eq '12' THEN SAM_meduc = 2;
  else if '12' < SAM_EDUMOM <= '15' then SAM_meduc = 3;
  else if '15' < SAM_EDUMOM < '22' then SAM_meduc = 4;
  else SAM_meduc = 5;

 SAM_feduc3 = .;
  IF '0' <= SAM_EDUDAD < '12' THEN SAM_Feduc = 1;
  else if SAM_EDUDAD eq '12' THEN SAM_Feduc = 2;
  else if '12' < SAM_EDUDAD <= '15' then SAM_Feduc = 3;
  else if '15' < SAM_EDUDAD < '22' then SAM_Feduc = 4;
  else SAM_Feduc = 4;

/* recode marital status */
SAM_married = .;
  if SAM_MARITAL = 1 then SAM_married = 1;
  else if SAM_MARITAL = 2 then SAM_married = 0;
  else SAM_married = 2;


/* code Kessner's Index of adequacy of prenatal care */
  /* note this is modified - it does not account for
     the place of delivery (private obstetrical service req'd
     for adequate care) */

SAM_Kessner = 2;
  if SAM_combgest_final=99 or SAM_combgest_final=. or SAM_PNC=. or SAM_PNCVST_TOTAL=. then SAM_Kessner =4;
  else if (SAM_PNC > 6) or
    ((14 <= SAM_combgest_final <= 21) and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL = 0 or SAM_PNC=.)) or
    ((22 <= SAM_combgest_final <= 29) and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL <= 1)) or
    ((30 <= SAM_combgest_final <= 31) and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL <= 2)) or
    ((32 <= SAM_combgest_final <= 33) and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL <= 3)) or
    (SAM_combgest_final >= 34 and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL <= 4)) then SAM_Kessner = 3;
  else if (SAM_PNC <= 3) and
    (SAM_combgest_final <= 13 and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL >= 1)) or
    ((14 <= SAM_combgest_final <= 17) and SAM_PNCVST_TOTAL >= 2) or
    ((18 <= SAM_combgest_final <= 21) and SAM_PNCVST_TOTAL >= 3) or
    ((22 <= SAM_combgest_final <= 25) and SAM_PNCVST_TOTAL >= 4) or
    ((26 <= SAM_combgest_final <= 29) and SAM_PNCVST_TOTAL >= 5) or
    ((30 <= SAM_combgest_final <= 31) and SAM_PNCVST_TOTAL >= 6) or
    ((32 <= SAM_combgest_final <= 33) and SAM_PNCVST_TOTAL >= 7) or
    ((34 <= SAM_combgest_final <= 35) and SAM_PNCVST_TOTAL >= 8) or
    (SAM_combgest_final >= 36 and SAM_PNCVST_TOTAL >= 9) then SAM_Kessner = 1;

RUN;
/*Table 1 - mothers characteristics*/

PROC FREQ DATA = livefnh1;
TABLES RACEHISP SAM_MAGE SAM_meduc SAM_feduc PTB_CAT1 SAM_Kessner SAM_married;
RUN;
/*By race-ethnicty*/
PROC FREQ DATA = livefnh1;
TABLES (SAM_MAGE SAM_meduc SAM_Feduc SAM_married SAM_Kessner)*RACEHISP;
TITLE "Kessner's Index of adequacy of prenatal care by race among women delivering between 1979-1983";
FORMAT RACEHISP $RACEETH. SAM_meduc feduc6x.;
RUN;
