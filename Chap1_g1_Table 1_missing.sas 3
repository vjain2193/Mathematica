/*****************************************************
PURPOSE: To do the descritptive analysis for generation 1, 1979-1983
We will do this analysis by race, preterm category and education
DATA: 3/31/16 
We also have deleted all the dates that have missing month - 2314 records;
Days+month = 32111
******************************************************/
libname DT 'C:\Users\njain\Documents\Personal\Dissertation\Final data creation\Final_data\Final_deidentified data';
LIBNAME VA 'C:\Users\njain\Documents\Personal\Dissertation\Final data creation\Matching data\Matching_762015';

DATA link_table1;
	SET DT.ANALYDATA;
	SAMBWT =input(SAM_WT,comma9.);
	MATBWT =input(BWT,comma9.);
    dates_char = put(imputed_date,mmddYY10.);
	BIRTHWT_F=input(BWT,best4.);
	GEST_WK2=put(MAT_COMBGEST,4.0);

/*Categorizing ethnicity*/
	IF M_HISP EQ 0 AND M_RACE EQ 1 THEN RACEHISP = 0; /*NH WHITE*/
	ELSE IF M_HISP EQ 0 AND M_RACE EQ 2 THEN RACEHISP = 1; /*NH BLLACK*/
	ELSE IF M_HISP IN (1,2,3,4,5) THEN RACEHISP = 2; /*Hispanic*/
	ELSE RACEHISP = 3; 


RUN;
DATA CHAP1;
	SET link_table1;
	S_Mm = input(substr(dates_char,1,2),8.);
    S_Dd = input(substr(dates_char,4,2),8.);
    S_Yy = input(substr(dates_char,7,4),8.); 
    M_Mm = input(substr(MDOB,1,2),8.);
    M_Dd = input(substr(MDOB,3,2),8.);
    M_Yy = input(substr(MDOB,5,4),8.); 
	RACEHISP2 = put (RACEHISP,2.0);

/*using the MDY function, create the SAS date-these can be used in INTCK function later to calculate time intervals*/
    SAM_Var = MDY(S_Mm,S_Dd,S_Yy); *Sample moms LMP;
	MOM_VAR = MDY(M_Mm,M_Dd,M_Yy); *Samples DOB;

/*Calculating weejs for PTB*/
	SAM_combgest_final = intck('week', SAM_VAR, MOM_Var);
RUN;
/*converting this to final data set*/

DATA DT.FINALDATA_ANL;
	SET CHAP1;
	/* convert character to numeric */
BIRTHWT_F=input(SAM_WT,best4.);

/* convert numeric to character */
GEST_WK=put(SAM_combgest_final,4.0);
RUN;

DATA livefnh1;
	SET DT.FINALDATA_ANL;

	/*extremely preterm (<28 weeks)
very preterm (28 to <32 weeks)
moderate to late preterm (32 to <37 weeks).*/

	IF SAM_combgest_final < 20 | SAM_combgest_final > 47 THEN delete;
	ELSE IF 20 < SAM_combgest_final <32 THEN SAM_PTB4 = 0;
	ELSE IF 32 <= SAM_combgest_final <37 THEN SAM_PTB4 = 1;
	ELSE IF 37 <= SAM_combgest_final <=47 THEN SAM_PTB4 = 2;

 /*Just to create PTB and non-PTB*/
	IF 20 < GEST_WK < 38 THEN PTB_CAT1 = 1;
	ELSE IF 38 <= GEST_WK <=47 THEN PTB_CAT1 = 0;
	ELSE delete;

/*Using race/ethnicity from generation 2 and using it for generation 1*/
MAT_race = .;
  if M_RACE EQ '1' then MAT_MRACE = 1; /* White */
  else if M_RACE = '2' then MAT_MRACE = 2; /* Black */
  else MAT_MRACE = 3;  /* NH other */

/* recode maternal age */
SAM_MAGE3 = .;
  if '12' <= SAM_AGEMOM < '20' then SAM_MAGE3 = 1;
  else if '20' <= SAM_AGEMOM < '25' then SAM_MAGE3 = 2;
  else if '25' <= SAM_AGEMOM < '30' then SAM_MAGE3 = 3;
  else if '30' <= SAM_AGEMOM < '35' then SAM_MAGE3 = 4;
  else if '35' <= SAM_AGEMOM < '55' then SAM_MAGE3 = 5;
  else DELETE;

/* recode maternal education */
SAM_meduc3 = .;
  IF 0 <= SAM_EDUMOM < 12 THEN SAM_meduc3 = 1;
  else if SAM_EDUMOM eq '12' THEN SAM_meduc3 = 2; 
  else if '12' < SAM_EDUMOM < '99' then SAM_meduc3 = 3;
  else DELETE;

 SAM_feduc3 = .;
  IF 0 <= SAM_EDUDAD < 12 THEN SAM_Feduc3 = 1;
  else if SAM_EDUDAD eq '12' THEN SAM_Feduc3 = 2; 
  else if '12' < SAM_EDUDAD < '22' then SAM_Feduc3 = 3;
  else DELETE;

/* recode marital status */
SAM_married = .;
  if SAM_MARITAL = 1 then SAM_married = 1;
  else if SAM_MARITAL = 2 then SAM_married = 0;        
  else delete;

/* recode maternal education */
SAM_meduc = .;
  IF 0 <= SAM_EDUMOM < 9 THEN SAM_meduc = 1;
  ELSE IF 9 <= SAM_EDUMOM < 12 THEN SAM_meduc = 2;
  else if SAM_EDUMOM eq '12' THEN SAM_meduc = 3; 
  else if '12' < SAM_EDUMOM <= '15' then SAM_meduc = 4;
  else if '15' < SAM_EDUMOM < '22' then SAM_meduc = 5;
  else DELETE;

SAM_Feduc = .;
  IF 0 <= SAM_EDUDAD < 9 THEN SAM_Feduc = 1;
  ELSE IF 9 <= SAM_EDUDAD < 12 THEN SAM_Feduc = 2;
  else if SAM_EDUDAD eq '12' THEN SAM_Feduc = 3; 
  else if '12' < SAM_EDUDAD <= '15' then SAM_Feduc = 4;
  else if '15' < SAM_EDUDAD < '22' then SAM_Feduc = 5;
  else DELETE;

/* recode marital status */
SAM_married = .;
  if SAM_MARITAL = 1 then SAM_married = 1;
  else if SAM_MARITAL = 2 then SAM_married = 0; 
  else DELETE;
 
/* code Kessner's Index of adequacy of prenatal care */
  /* note this is modified - it does not account for
     the place of delivery (private obstetrical service req'd
     for adequate care) */

SAM_Kessner = 2;
  if SAM_combgest_final=99 or SAM_combgest_final=. or SAM_PNC=. or SAM_PNCVST_TOTAL=. then SAM_Kessner = 4;
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

/*final model without kessner*/
PROC LOGISTIC DATA = livefnh1 descending;
class SAM_MAGE3(param=ref ref="3") 
	  SAM_meduc (param=ref ref="4")
	  SAM_Feduc (param=ref ref="4")
	  SAM_Kessner (param=ref ref="1");
where RACEHISP EQ 0;
MODEL PTB_CAT1 = SAM_MAGE3 SAM_meduc SAM_Feduc SAM_married SAM_Kessner;
RUN;
PROC LOGISTIC DATA = livefnh1 descending;
class SAM_MAGE3(param=ref ref="3") 
	  SAM_meduc (param=ref ref="4")
	  SAM_Feduc (param=ref ref="4");
where RACEHISP EQ 1;
MODEL PTB_CAT1 = SAM_MAGE3 SAM_meduc SAM_Feduc SAM_married SAM_Kessner;
RUN;
PROC LOGISTIC DATA = livefnh1 descending;
class SAM_MAGE3(param=ref ref="3") 
	  SAM_meduc (param=ref ref="4")
	  SAM_Feduc (param=ref ref="4");
where RACEHISP EQ 2;
MODEL PTB_CAT1 = SAM_MAGE3 SAM_meduc SAM_Feduc SAM_married SAM_Kessner ;
RUN;

/*overall except for SGA*/
PROC FREQ DATA = livefnh1 nmiss cmiss;
TABLES RACEHISP*PTB_CAT1;
*tables RACEHISP*PTB_CAT0;
*tables PTB_CAT1 PTB_CAT0;
RUN;
/*overall except for SGA*/
PROC FREQ DATA = livefnh1;
TABLES RACEHISP SAM_MAGE3 SAM_meduc SAM_feduc PTB_CAT1 SAM_LBW SAM_Kessner SAM_married SGA_WNHF_G1 SGA_BNHFG1 SGA_NHFG1;
format RACEHISP fmrace. SAM_MAGE3 fmage3x. SAM_meduc fmeduc3x. SAM_feduc fmeduc3x. 
SAM_PTB4 fPTBRE. SAM_LBW fy1n0x. SAM_Kessner fKessner. SAM_married fy1n0x. ;
RUN;
/*we do freq by ptb_Cat*mat_meduc3, since we want col percent that tell the rate of the mothers that
preterm that had certain education level or other characteristics; if we do it other way we need to look at row percent*/

/*BY RACE & ETHNICITY*/
PROC FREQ DATA = livefnh1;
TABLES PTB_CAT1*SAM_MAGE3;
where racehisp eq 2;
TITLE "Preterm births by race among women delivering between 1979-1983";
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_LBW)*RACEHISP;
TITLE "Low birthweight by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. SAM_LBW fy1n0x.;
RUN;
PROC FREQ DATA = livefnh1;
TABLES SAM_MAGE3*RACEHISP;
TITLE "Materanl age by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. ;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_Kessner)*RACEHISP;
TITLE "Kessner's Index of adequacy of prenatal care by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. SAM_Kessner fKessner.;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_meduc)*RACEHISP;
TITLE "Materanl education by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. SAM_meduc feduc6x.;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (foreign)*RACEHISP;
TITLE "Materanl MARITAL by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. ;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_marital)*RACEHISP;
TITLE "Materanl MARITAL by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. ;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_Feduc)*RACEHISP;
TITLE "Materanl education by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. SAM_Feduc feduc6x.;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (sam_sex sex)*RACEHISP;
TITLE "Materanl education by race among women delivering between 1999-2011";
FORMAT RACEHISP fmrace. MAT_Feduc feduc6x.;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_PTB3)*RACEHISP;
TITLE "Preterm births by race among women delivering between 1979-1983";
format RACEHISP fmrace. SAM_PTB4 fPTBRE.;
RUN;

/*By race-ethnicty*/
PROC FREQ DATA = livefnh1;
TABLES (SAM_PTB4)*SAM_meduc;
WHERE RACEHISP EQ 0;
TITLE "Preterm births by race among women delivering between 1979-1983";
format RACEHISP fmrace. SAM_PTB4 fPTB.;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_LBW)*RACEHISP;
TITLE "Low birthweight by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. SAM_LBW fy1n0x.;
RUN;
PROC FREQ DATA = livefnh1;
TABLES SAM_MAGE3*RACEHISP;
TITLE "Materanl age by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. ;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_Kessner)*RACEHISP;
TITLE "Kessner's Index of adequacy of prenatal care by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. SAM_Kessner fKessner.;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_meduc)*RACEHISP;
TITLE "Materanl education by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. SAM_meduc feduc6x.;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_married)*RACEHISP;
TITLE "Materanl MARITAL by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. ;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_Feduc)*RACEHISP;
TITLE "Materanl education by race among women delivering between 1979-1983";
FORMAT RACEHISP fmrace. SAM_Feduc feduc6x.;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (sam_sex)*RACEHISP;
TITLE "Materanl education by race among women delivering between 1999-2011";
FORMAT RACEHISP fmrace. MAT_Feduc feduc6x.;
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_PTB3)*RACEHISP;
TITLE "Preterm births by race among women delivering between 1979-1983";
format RACEHISP fmrace. SAM_PTB4 fPTBRE.;
RUN;

