/*****************************************************
PURPOSE: To do the descriptive analysis for generation 1, 1979-1983
We will do this analysis by race, preterm category and education
Adapted from Chap2_g1_regression.sas for the Jenner compatibility bundle:
the original built livefnh1 from LIBNAME DT/VA data pointing at the
author's private local dissertation files. Here livefnh1 is a small inline
mock cohort carrying PTB_CAT1 (already-categorized preterm/term outcome)
plus the raw maternal fields (M_HISP, M_RACE, SAM_AGEMOM, SAM_EDUMOM) the
BIN_REG step recodes. The RACEHISP / SAM_MAGE3 / SAM_meduc3 recoding and
the unadjusted + adjusted PROC LOGISTIC regressions below -- using
CLASS ... (param=ref ref="...") reference coding on the preterm-birth
outcome -- are the author's own modeling approach, unchanged (trimmed to
a representative slice of the ~15 LOGISTIC calls in the source file).
******************************************************/

data livefnh1;
  input PTB_CAT1 M_HISP M_RACE SAM_AGEMOM SAM_EDUMOM SAM_MARITAL;
  datalines;
1 0 1 24 12 1
0 0 1 31 16 1
1 0 2 19 9  2
0 0 2 28 12 1
1 1 3 22 11 2
0 1 3 33 15 1
1 2 4 26 8  2
0 2 4 36 14 1
1 0 1 18 9  2
0 0 2 29 13 1
1 1 3 21 10 2
0 0 1 34 16 1
1 2 4 23 7  2
0 1 3 30 12 1
1 0 1 20 11 2
0 0 2 27 14 1
;
run;

DATA BIN_REG;
	SET livefnh1;

	/* recode maternal age */
SAM_MAGE3 = .;
  if '12' <= SAM_AGEMOM < '20' then SAM_MAGE3 = 1;
  else if '20' <= SAM_AGEMOM < '25' then SAM_MAGE3 = 2;
  else if '25' <= SAM_AGEMOM < '30' then SAM_MAGE3 = 3;
  else if '30' <= SAM_AGEMOM < '35' then SAM_MAGE3 = 4;
  else if '35' <= SAM_AGEMOM < '55' then SAM_MAGE3 = 5;
  else SAM_MAGE3 = 6;

/* recode maternal education */
SAM_meduc3 = .;
  IF 0 <= SAM_EDUMOM < 12 THEN SAM_meduc3 = 0;
  else if SAM_EDUMOM eq '12' THEN SAM_meduc3 = 1;
  else if '12' < SAM_EDUMOM < '99' then SAM_meduc3 = 2;
  else SAM_meduc3 = 3;

/*Using race/ethnicity from generation 2 and using it for generation 1*/

	IF M_HISP EQ 0 AND M_RACE EQ 1 THEN RACEHISP = 0; /*NH WHITE*/
	ELSE IF M_HISP EQ 0 AND M_RACE EQ 2 THEN RACEHISP = 1; /*NH BLLACK*/
	ELSE IF M_HISP IN (1,2,3,4,5) THEN RACEHISP = 2; /*Hispanic*/
	ELSE RACEHISP = 3;

	/* recode marital status 0=yes married 1=not married*/
	SAM_married = .;
	  if SAM_MARITAL = 1 then SAM_married = 0;
	  else if SAM_MARITAL = 2 then SAM_married = 1;
	  else SAM_married = 2;
RUN;

PROC FREQ DATA = BIN_REG;
TABLES PTB_CAT1*SAM_meduc3 /trend measures cl;
WHERE RACEHISP EQ 0;
RUN;

/*************Regression analysis****************/

PROC LOGISTIC DATA = BIN_REG descending;
class RACEHISP(param=ref ref="0");
MODEL PTB_CAT1 = RACEHISP;
RUN;

PROC LOGISTIC DATA = BIN_REG descending;
class SAM_MAGE3(param=ref ref="3");
MODEL PTB_CAT1 = SAM_MAGE3;
RUN;

PROC LOGISTIC DATA = BIN_REG descending;
class SAM_married (param=ref ref="0");
MODEL PTB_CAT1 = SAM_married;
RUN;

/**********Adjusted OR**********/
PROC LOGISTIC DATA = BIN_REG descending;
class SAM_meduc3 (param=ref ref="1")
	  RACEHISP(param=ref ref="0");
MODEL PTB_CAT1 = SAM_meduc3 RACEHISP;
RUN;
