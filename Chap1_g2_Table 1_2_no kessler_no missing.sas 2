/*****************************************************
PURPOSE: To do the descritptive analysis for generation 1, 1979-1983
We will do this analysis by race, preterm category and education
DATA: 3/31/16 
******************************************************/
libname DT 'C:\Users\njain\Documents\Personal\Dissertation\Data_NJ\Final_data\Final_deidentified data';

LIBNAME VA 'C:\Users\njain\Documents\Personal\Dissertation\Data_NJ\Matching data\Matching_762015';
/*USING DT.ANALYDATA this as final data, not VA.finalrecode_link*/

DATA link1;
	SET DT.ANALYDATA;

/*extremely preterm (<28 weeks)
very preterm (28 to <32 weeks)
moderate to late preterm (32 to <37 weeks).*/

	IF MAT_COMBGEST < 20 | MAT_COMBGEST > 47 THEN delete;
	ELSE IF 20 < MAT_COMBGEST <32 THEN MAT_PTB4 = 0;
	ELSE IF 32 <= MAT_COMBGEST <37 THEN MAT_PTB4 = 1;
	ELSE IF 37 <= MAT_COMBGEST <=47 THEN MAT_PTB4 = 2;

/*Just to create PTB and non-PTB*/

	IF 20 < MAT_COMBGEST < 38 THEN PTB_CAT1 = 1;
	ELSE IF 38 <= MAT_COMBGEST <=47 THEN PTB_CAT1 = 0;
	else delete;

/*Using race/ethnicity from generation 2 and using it for generation 1*/

	IF M_HISP EQ 0 AND M_RACE EQ 1 THEN RACEHISP = 0; /*NH WHITE*/
	ELSE IF M_HISP EQ 0 AND M_RACE EQ 2 THEN RACEHISP = 1; /*NH BLLACK*/
	ELSE IF M_HISP IN (1,2,3,4,5) THEN RACEHISP = 2; /*Hispanic*/
	ELSE RACEHISP = 3; 

/* recode maternal age: Per DD there are no mothers over 35 years so 6 is missing */
MAT_MAGE6 = .;
  if mage_cat in (4, 5) then MAT_MAGE6 = 1;
  else if mage_cat eq 6 then MAT_MAGE6 = 2;
  else if mage_cat eq 7 then MAT_MAGE6 = 3;
  else if mage_cat eq 8 then MAT_MAGE6 = 4;
  else delete;

/* recode maternal and paternal education */
MAT_meduc = .;
  IF 0 <= M_EDU < 9 THEN MAT_meduc = 1;
  ELSE IF 9 <= M_EDU < 12 THEN MAT_meduc = 2;
  else if M_EDU eq 12 THEN MAT_meduc = 3; 
  else if 12 < M_EDU <= 15 then MAT_meduc = 4;
  else if 15 < M_EDU < 99 then MAT_meduc = 5;
  else delete;

MAT_Feduc = .;
  IF 0 <= F_EDU < 9 THEN MAT_Feduc = 1;
  ELSE IF 9 <= F_EDU < 12 THEN MAT_Feduc = 2;
  else if F_EDU eq 12 THEN MAT_Feduc = 3; 
  else if 12 < F_EDU <= 15 then MAT_Feduc = 4;
  else if 15 < F_EDU < 99 then MAT_Feduc = 5;
  else delete;

/* recode marital status 1 = married 0 = no*/
MAT_married = .;
  if M_MARRIED = 1 then MAT_married = 1;
  else if M_MARRIED = 2 then MAT_married = 0;  
  else delete;

SAM_meduc = .;
  IF 0 <= SAM_EDUMOM < 9 THEN SAM_meduc = 1;
  else if 9 <= SAM_EDUMOM < 12 THEN SAM_meduc = 2;
  else if SAM_EDUMOM eq 12 THEN SAM_meduc = 3; 
  else if 12 < SAM_EDUMOM <= 15 then SAM_meduc = 4;
  else if 15 < SAM_EDUMOM < 22 then SAM_meduc = 5;
  else delete;
RUN;
proc freq; tables ptb_cat1;
run;
/*Model without Kessner and without grand mom*/

PROC LOGISTIC DATA = link1 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4");
WHERE RACEHISP = 0;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc  MAT_married;
RUN;

PROC LOGISTIC DATA = link1 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4");
WHERE RACEHISP = 1;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc MAT_married;
RUN;
PROC LOGISTIC DATA = link1 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4");
WHERE RACEHISP = 2;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc MAT_married;
RUN;

/*Model without Kessner and with grand mom AND NO MISSING*/
PROC LOGISTIC DATA = LINK1 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
  	  SAM_meduc (param=ref ref="4");
WHERE RACEHISP = 0;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc SAM_meduc MAT_married;
RUN;
PROC LOGISTIC DATA = LINK1 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
  	  SAM_meduc (param=ref ref="4");
WHERE RACEHISP = 1;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc SAM_meduc MAT_married;
RUN;
PROC LOGISTIC DATA = LINK1 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
  	  SAM_meduc (param=ref ref="4");
WHERE RACEHISP = 2;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc SAM_meduc MAT_married;
RUN;

