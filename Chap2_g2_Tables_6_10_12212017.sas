/*****************************************************
PURPOSE: To do the descritptive analysis for generation 1, 1979-1983
We will do this analysis by race, preterm category and education
DATA: 3/31/16 
******************************************************/
libname DT 'C:\Users\njain\Documents\Personal\Dissertation\Final data creation\Final_data\Final_deidentified data';
LIBNAME VA 'C:\Users\njain\Documents\Personal\Dissertation\Final data creation\Matching data\Matching_762015';

/*USING DT.ANALYDATA this as final data, not VA.finalrecode_link or FINALDATA_ANL since this has only records with deleted missing LMP*/

DATA link1;
	SET DT.ANALYDATA;

/*DT.FINALDATA_ANL*/;

/*extremely preterm (<28 weeks); very preterm (28 to <32 weeks);moderate to late preterm (32 to <37 weeks).*/

	IF MAT_COMBGEST < 20 | MAT_COMBGEST > 47 THEN MAT_PTB4= 3;
	ELSE IF 20 < MAT_COMBGEST <32 THEN MAT_PTB4 = 0;
	ELSE IF 32 <= MAT_COMBGEST <37 THEN MAT_PTB4 = 1;
	ELSE IF 37 <= MAT_COMBGEST <=47 THEN MAT_PTB4 = 2;

/*Just to create PTB and non-PTB and delete the missing, <20 and gt >47*/

	IF 20 < MAT_COMBGEST < 38 THEN PTB_CAT = 1;
	ELSE IF 38 <= MAT_COMBGEST <=47 THEN PTB_CAT = 0;
	ELSE PTB_CAT = 2;

/*Using race/ethnicity from generation 2 and using it for generation 1*/

	IF M_RACE EQ 0 THEN RACEHISP_CAT = 5;
	ELSE IF M_HISP EQ 0 AND M_RACE EQ 1 THEN RACEHISP_CAT = 0; /*NH WHITE*/
	ELSE IF M_HISP EQ 0 AND M_RACE EQ 2 THEN RACEHISP_CAT = 1; /*NH BLLACK*/
	ELSE IF M_RACE GT 2 THEN RACEHISP_CAT = 2;
	ELSE IF M_HISP IN (1,2,3,4,5) THEN RACEHISP_CAT = 3; /*Hispanic*/
	ELSE IF M_HSIP GT 5 THEN RACEHISP_CAT = 4;

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
  IF 0 <= M_EDU < 12 THEN MAT_meduc = 1;
  else if M_EDU eq 12 THEN MAT_meduc = 2; 
  else if 12 < M_EDU <= 15 then MAT_meduc = 3;
  else if 15 < M_EDU < 18 then MAT_meduc = 4;
  else MAT_meduc = 5;


MAT_Feduc = .;
  IF 0 <= F_EDU < 12 THEN MAT_Feduc = 1;
  else if F_EDU eq 12 THEN MAT_Feduc = 2; 
  else if 12 < F_EDU <= 15 then MAT_Feduc = 3;
  else if 15 < F_EDU < 18 then MAT_Feduc = 4;
  else MAT_Feduc = 5;

/* recode marital status 1 = married 0 = no*/
MAT_married = .;
  if M_MARRIED = 1 then MAT_married = 1;
  else if M_MARRIED = 2 then MAT_married = 0;  

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
  IF '0' <= SAM_EDUMOM < '12' THEN SAM_meduc = 1;
  else if SAM_EDUMOM eq '12' THEN SAM_meduc = 2; 
  else if '12' < SAM_EDUMOM <= '15' then SAM_meduc = 3;
  else if '15' < SAM_EDUMOM < '18' then SAM_meduc = 4;
  else SAM_meduc = 5;

RUN;

DATA link2;
	SET link1;
	IF PLURALITY GT 1 THEN DELETE;

	/* convert character to numeric */
BIRTHWT_F2=input(BWT,best4.);

/* convert numeric to character */
GEST_WK2=put(MAT_COMBGEST,2.0);
RACEHISP2 = put (RACEHISP,2.0);

/*DELETING RACEETH_CAT 2, 4, 5 and just keeping black,white & hisp*/

	IF RACEHISP_CAT EQ 0 THEN RACEHISP = 0;/*NH WHITE*/
	ELSE IF RACEHISP_CAT EQ 1 THEN RACEHISP = 1; /*NH BLLACK*/
	ELSE IF RACEHISP_CAT EQ 3 THEN RACEHISP = 2; /*Hispanic*/
	ELSE DELETE;

RUN;
/*for ptb rates tables*/
DATA LINK4;
	SET link2;
	IF ptb_cat GT 1 THEN DELETE;

	/* convert character to numeric */
BIRTHWT_F2=input(BWT,best4.);

/* convert numeric to character */
GEST_WK2=put(MAT_COMBGEST,2.0);
RACEHISP2 = put (RACEHISP,2.0);

/*DELETING RACEETH_CAT 2, 4, 5 and just keeping black,white & hisp*/

	IF RACEHISP_CAT EQ 0 THEN RACEHISP = 0;/*NH WHITE*/
	ELSE IF RACEHISP_CAT EQ 1 THEN RACEHISP = 1; /*NH BLLACK*/
	ELSE IF RACEHISP_CAT EQ 3 THEN RACEHISP = 2; /*Hispanic*/
	ELSE DELETE;

RUN;
/*************Regression analysis wnh****************/

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3"); 
WHERE RACEHISP = 0;
MODEL PTB_CAT = MAT_MAGE6;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_meduc(param=ref ref="3"); 
WHERE RACEHISP = 0;
MODEL PTB_CAT = MAT_meduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class SAM_meduc(param=ref ref="3");
WHERE RACEHISP = 0;
MODEL PTB_CAT = SAM_meduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_Feduc(param=ref ref="3"); 
WHERE RACEHISP = 0;
MODEL PTB_CAT = MAT_Feduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_married (param=ref ref="1"); 
WHERE RACEHISP = 0;
MODEL PTB_CAT =  MAT_married;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_Kessner(param=ref ref="1"); 
WHERE RACEHISP = 0;
MODEL PTB_CAT =  MAT_Kessner;
RUN; 

/*Final Regression without Grandmom*/

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="3")
	  MAT_Feduc (param=ref ref="3")
	  MAT_Kessner (param=ref ref="1")
	  MAT_married (param=ref ref="1");
WHERE RACEHISP = 0;
MODEL PTB_CAT = MAT_MAGE6 MAT_meduc MAT_Feduc MAT_married MAT_Kessner ;
RUN; 

/*************Regression analysis bnh****************/

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3"); 
WHERE RACEHISP = 1;
MODEL PTB_CAT = MAT_MAGE6;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_meduc(param=ref ref="3"); 
WHERE RACEHISP = 1;
MODEL PTB_CAT = MAT_meduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class SAM_meduc(param=ref ref="3");
WHERE RACEHISP = 1;
MODEL PTB_CAT = SAM_meduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_Feduc(param=ref ref="3"); 
WHERE RACEHISP = 1;
MODEL PTB_CAT = MAT_Feduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_married (param=ref ref="1"); 
WHERE RACEHISP = 1;
MODEL PTB_CAT =  MAT_married;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_Kessner(param=ref ref="1"); 
WHERE RACEHISP = 1;
MODEL PTB_CAT =  MAT_Kessner;
RUN; 

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="3")
	  MAT_Feduc (param=ref ref="3")
	  MAT_Kessner (param=ref ref="1")
	  MAT_married (param=ref ref="1");
WHERE RACEHISP = 1;
MODEL PTB_CAT = MAT_MAGE6 MAT_meduc MAT_Feduc MAT_married MAT_Kessner ;
RUN; 
/*************Regression analysis hispnaic****************/

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3"); 
WHERE RACEHISP = 2;
MODEL PTB_CAT = MAT_MAGE6;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_meduc(param=ref ref="3"); 
WHERE RACEHISP = 2;
MODEL PTB_CAT = MAT_meduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class SAM_meduc(param=ref ref="3");
WHERE RACEHISP = 2;
MODEL PTB_CAT = SAM_meduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_Feduc(param=ref ref="3"); 
WHERE RACEHISP = 2;
MODEL PTB_CAT = MAT_Feduc;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_married (param=ref ref="1"); 
WHERE RACEHISP = 2;
MODEL PTB_CAT =  MAT_married;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_Kessner(param=ref ref="1"); 
WHERE RACEHISP = 2;
MODEL PTB_CAT =  MAT_Kessner;
RUN; 
PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="3")
	  MAT_Feduc (param=ref ref="3")
	  MAT_Kessner (param=ref ref="1")
	  MAT_married (param=ref ref="1");
WHERE RACEHISP = 2;
MODEL PTB_CAT = MAT_MAGE6 MAT_meduc MAT_Feduc MAT_married MAT_Kessner ;
RUN; 
/*Final Regression with Grandmom*/

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="3")
	  MAT_Feduc (param=ref ref="3")
  	  SAM_meduc (param=ref ref="3")
	  MAT_Kessner (param=ref ref="1")
	  MAT_married (param=ref ref="1");
WHERE RACEHISP = 0;
MODEL PTB_CAT = MAT_MAGE6 MAT_meduc MAT_Feduc SAM_meduc MAT_married MAT_Kessner ;
RUN;

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="3")
	  MAT_Feduc (param=ref ref="3")
  	  SAM_meduc (param=ref ref="3")
	  MAT_Kessner (param=ref ref="1")
	  MAT_married (param=ref ref="1");
WHERE RACEHISP = 1;
MODEL PTB_CAT = MAT_MAGE6 MAT_meduc MAT_Feduc SAM_meduc MAT_married MAT_Kessner ;
RUN;

PROC LOGISTIC DATA = LINK4 descending;
class MAT_MAGE6(param=ref ref="3") 
	  MAT_meduc (param=ref ref="3")
	  MAT_Feduc (param=ref ref="3")
  	  SAM_meduc (param=ref ref="3")
	  MAT_Kessner (param=ref ref="1")
	  MAT_married (param=ref ref="1");
WHERE RACEHISP = 2;
MODEL PTB_CAT = MAT_MAGE6 MAT_meduc MAT_Feduc SAM_meduc MAT_married MAT_Kessner ;
RUN;
