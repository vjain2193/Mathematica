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

/*extremely preterm (<28 weeks); very preterm (28 to <32 weeks); moderate to late preterm (32 to <37 weeks).*/

	IF MAT_COMBGEST < 20 | MAT_COMBGEST > 47 THEN MAT_PTB4= 3;
	ELSE IF 20 < MAT_COMBGEST <32 THEN MAT_PTB4 = 0;
	ELSE IF 32 <= MAT_COMBGEST <37 THEN MAT_PTB4 = 1;
	ELSE IF 37 <= MAT_COMBGEST <=47 THEN MAT_PTB4 = 2;

/*Just to create PTB and non-PTB*/

	IF 20 < MAT_COMBGEST < 38 THEN PTB_CAT1 = 1;
	ELSE IF 38 <= MAT_COMBGEST <=47 THEN PTB_CAT1 = 0;

/*Using race/ethnicity from generation 2 and using it for generation 1*/

	IF M_HISP EQ 0 AND M_RACE EQ 1 THEN RACEHISP = 0; /*NH WHITE*/
	ELSE IF M_HISP EQ 0 AND M_RACE EQ 2 THEN RACEHISP = 1; /*NH BLLACK*/
	ELSE IF M_HISP IN (1,2,3,4,5) THEN RACEHISP = 2; /*Hispanic*/
	ELSE RACEHISP = 3; 

/* WEIGHT */
 MAT_LBW= .;
  if '0' < BWT < '2500' then MAT_LBW = 1;
  else if '2500' <= BWT < '9999' then MAT_LBW = 0;  

/* recode maternal age: Per DD there are no mothers over 35 years so 6 is missing */
MAT_MAGE6 = .;
  if mage_cat in (4, 5) then MAT_MAGE6 = 1;
  else if mage_cat eq 6 then MAT_MAGE6 = 2;
  else if mage_cat eq 7 then MAT_MAGE6 = 3;
  else if mage_cat eq 8 then MAT_MAGE6 = 4;
  else if 9 <=mage_cat <=19 then MAT_MAGE6 = 5;
  else MAT_MAGE6 = 6;

/* recode maternal and paternal education */
MAT_meduc = .;
  IF 0 <= M_EDU < 9 THEN MAT_meduc = 1;
  ELSE IF 9 <= M_EDU < 12 THEN MAT_meduc = 2;
  else if M_EDU eq 12 THEN MAT_meduc = 3; 
  else if 12 < M_EDU <= 15 then MAT_meduc = 4;
  else if 15 < M_EDU < 99 then MAT_meduc = 5;
  else MAT_meduc = 6;

/* recode maternal education */
MAT_meduc3 = .;
  IF 0 <= M_EDU < 12 THEN MAT_meduc3 = 0;
  else if M_EDU eq 12 THEN MAT_meduc3 = 1; 
  else if 12 < M_EDU < 99 then MAT_meduc3 = 2;
  else MAT_meduc3 = 3;

MAT_Feduc = .;
  IF 0 <= F_EDU < 9 THEN MAT_Feduc = 1;
  ELSE IF 9 <= F_EDU < 12 THEN MAT_Feduc = 2;
  else if F_EDU eq 12 THEN MAT_Feduc = 3; 
  else if 12 < F_EDU <= 15 then MAT_Feduc = 4;
  else if 15 < F_EDU < 99 then MAT_Feduc = 5;
  else MAT_Feduc = 6;

MAT_Feduc3 = .;
  IF 0 <= F_EDU < 12 THEN MAT_Feduc3 = 1;
  else if F_EDU eq 12 THEN MAT_Feduc3 = 2; 
  else if 12 < F_EDU < 99 then MAT_Feduc3 = 3;
  else MAT_Feduc3 = 4;

/* recode marital status 1 = no 0 = yes*/
MAT_married = .;
  if M_MARRIED = 1 then MAT_married = 0;
  else if M_MARRIED = 2 then MAT_married = 1;  

/* code Kessner's Index of adequacy of prenatal care */
  /* note this is modified - it does not account for
     the place of delivery (private obstetrical service req'd
     for adequate care) */

MAT_Kessner = 2;
  if MAT_COMBGEST=99 or MAT_COMBGEST=. or MNTH_PREN_CARE =. or
     NUM_PREN_CARE  =. then MAT_Kessner = .;
  else if (MNTH_PREN_CARE > 6) or
    ((14 <= MAT_COMBGEST <= 21) and (NUM_PREN_CARE   = . or NUM_PREN_CARE   = 0 or MNTH_PREN_CARE =.)) or
    ((22 <= MAT_COMBGEST <= 29) and (NUM_PREN_CARE   = . or NUM_PREN_CARE   <= 1)) or
    ((30 <= MAT_COMBGEST <= 31) and (NUM_PREN_CARE   = . or NUM_PREN_CARE   <= 2)) or
    ((32 <= CLIN_EST_GEST <= 33) and (NUM_PREN_CARE   = . or NUM_PREN_CARE   <= 3)) or
    (MAT_COMBGEST >= 34 and (NUM_PREN_CARE   = . or NUM_PREN_CARE   <= 4)) then MAT_Kessner = 3;
  else if (MNTH_PREN_CARE  <= 3) and
    (MAT_combgest <= 13 and (NUM_PREN_CARE   = . or NUM_PREN_CARE   >= 1)) or
    ((14 <= MAT_COMBGEST <= 17) and NUM_PREN_CARE   >= 2) or
    ((18 <= MAT_COMBGEST <= 21) and NUM_PREN_CARE   >= 3) or
    ((22 <= MAT_COMBGEST <= 25) and NUM_PREN_CARE   >= 4) or
    ((26 <= MAT_COMBGEST <= 29) and NUM_PREN_CARE   >= 5) or
    ((30 <= MAT_COMBGEST <= 31) and NUM_PREN_CARE   >= 6) or
    ((32 <= MAT_COMBGEST <= 33) and NUM_PREN_CARE   >= 7) or
    ((34 <= MAT_COMBGEST <= 35) and NUM_PREN_CARE   >= 8) or
    (MAT_COMBGEST >= 36 and NUM_PREN_CARE   >= 9) then MAT_Kessner = 1;

SAM_meduc = .;
  IF 0 <= SAM_EDUMOM < 12 THEN SAM_meduc3 = 0;
  else if SAM_EDUMOM eq '12' THEN SAM_meduc3 = 1; 
  else if '12' < SAM_EDUMOM < '99' then SAM_meduc3 = 2;
  else SAM_meduc3 = 3;

SAM_meduc = .;
  IF 0 <= SAM_EDUMOM < 9 THEN SAM_meduc = 1;
  else if 9 <= SAM_EDUMOM < 12 THEN SAM_meduc = 2;
  else if SAM_EDUMOM eq 12 THEN SAM_meduc = 3; 
  else if 12 < SAM_EDUMOM <= 15 then SAM_meduc = 4;
  else if 15 < SAM_EDUMOM < 99 then SAM_meduc = 5;
  else SAM_meduc = 6;
RUN;

DATA link2;
	SET link1;
	/* convert character to numeric */
BIRTHWT_F2=input(BWT,best4.);

/* convert numeric to character */
GEST_WK2=put(MAT_COMBGEST,2.0);
RACEHISP2 = put (RACEHISP,2.0);
RUN;

/*************Regression analysis****************/

PROC LOGISTIC DATA = LINK4 descending;
class RACEHISP(param=ref ref="0"); 
MODEL PTB_CAT1 = RACEHISP;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3"); 
WHERE RACEHISP = 2;
MODEL PTB_CAT1 = MAT_MAGE6;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_meduc(param=ref ref="4"); 
WHERE RACEHISP = 2;
MODEL PTB_CAT1 = MAT_meduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class SAM_meduc(param=ref ref="4");
WHERE RACEHISP = 2;
MODEL PTB_CAT1 = SAM_meduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_Feduc(param=ref ref="4"); 
WHERE RACEHISP = 2;
MODEL PTB_CAT1 = MAT_Feduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_married (param=ref ref="0"); 
WHERE RACEHISP = 2;
MODEL PTB_CAT1 =  MAT_married;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_Kessner(param=ref ref="1"); 
WHERE RACEHISP = 2;
MODEL PTB_CAT1 =  MAT_Kessner;
RUN; 

/**********Adjusted OR**********/
PROC LOGISTIC DATA = LINK4 descending;
class MAT_meduc (param=ref ref="4")
	  RACEHISP(param=ref ref="0");
MODEL PTB_CAT1 =  MAT_meduc RACEHISP;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_meduc (param=ref ref="4")
	  RACEHISP(param=ref ref="0")
	  SAM_meduc(param=ref ref="4");
MODEL PTB_CAT1 =  MAT_meduc SAM_meduc RACEHISP;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_meduc (param=ref ref="4")
	  MAT_MAGE6(param=ref ref="3"); 	  
MODEL PTB_CAT1 = MAT_meduc MAT_MAGE6;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4");
MODEL PTB_CAT1 =  MAT_meduc MAT_Feduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class  MAT_meduc (param=ref ref="4");
MODEL PTB_CAT1 = MAT_meduc MAT_married;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_meduc (param=ref ref="4")
	  MAT_Kessner(param=ref ref="1"); 	  
MODEL PTB_CAT1 = MAT_meduc MAT_Kessner;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_meduc (param=ref ref="4");
MODEL PTB_CAT1 = MAT_meduc MAT_LBW;
RUN; 
/*****STEPWISE********/

PROC LOGISTIC DATA = LINK4 descending;
class RACEHISP (param=ref ref="0")
	 MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  SAM_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4");
MODEL PTB_CAT1 = MAT_meduc RACEHISP MAT_MAGE6;
RUN; 

PROC LOGISTIC DATA = LINK4 descending;
class RACEHISP (param=ref ref="0")
	  MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
	  RACEHISP(param=ref ref="0")
  	  SAM_meduc (param=ref ref="4")
	  MAT_Kessner (param=ref ref="1");
MODEL PTB_CAT1 = MAT_meduc SAM_meduc RACEHISP MAT_MAGE6 MAT_married ;
RUN; 

PROC LOGISTIC DATA = LINK4 descending;
class RACEHISP (param=ref ref="0")
	  MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  SAM_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
	  MAT_Kessner (param=ref ref="1");
MODEL PTB_CAT1 = MAT_meduc SAM_meduc RACEHISP MAT_MAGE6 MAT_married MAT_Feduc;
RUN; 
/*Final Regression*/
PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
	  MAT_Kessner (param=ref ref="1");
WHERE RACEHISP = 0;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc MAT_married MAT_Kessner ;
RUN; 

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
	  MAT_Kessner (param=ref ref="1");
WHERE RACEHISP = 1;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc MAT_married MAT_Kessner ;
RUN; 

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
	  MAT_Kessner (param=ref ref="1");
WHERE RACEHISP = 2;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc MAT_married MAT_Kessner ;
RUN; 
/*Final Regression without Grandmom*/

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
  	  SAM_meduc (param=ref ref="4")
	  MAT_Kessner (param=ref ref="1");
WHERE RACEHISP = 0;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc SAM_meduc MAT_married MAT_Kessner ;
RUN;

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
  	  SAM_meduc (param=ref ref="4")
	  MAT_Kessner (param=ref ref="1");
WHERE RACEHISP = 1;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc SAM_meduc MAT_married MAT_Kessner ;
RUN;

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
  	  SAM_meduc (param=ref ref="4")
	  MAT_Kessner (param=ref ref="1");
WHERE RACEHISP = 2;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc SAM_meduc MAT_married MAT_Kessner ;
RUN;

/*Model without Kessner and without grand mom*/

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4");
WHERE RACEHISP = 0;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc  MAT_married;
RUN;

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4");
WHERE RACEHISP = 1;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc MAT_married;
RUN;
PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4");
WHERE RACEHISP = 2;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc MAT_married;
RUN;

/*Model without Kessner and with grand mom*/
PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_Feduc (param=ref ref="4")
  	  SAM_meduc (param=ref ref="4")
MAT_Kessner (param=ref ref="1");
WHERE RACEHISP = 1;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_Feduc SAM_meduc MAT_married MAT_Kessner;
RUN;
PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
  	  SAM_meduc (param=ref ref="4");
WHERE RACEHISP = 0;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc SAM_meduc MAT_married;
RUN;
PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="4")
	  MAT_Feduc (param=ref ref="4")
  	  SAM_meduc (param=ref ref="4");
WHERE RACEHISP = 2;
MODEL PTB_CAT1 = MAT_MAGE6 MAT_meduc MAT_Feduc SAM_meduc MAT_married;
RUN;

