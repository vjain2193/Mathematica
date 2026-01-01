/*****************************************************
PURPOSE: To do the descritptive analysis (Table 1) for generation 1, 1979-1983
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

/*Using race/ethnicity from generation 2 and using it for generation 1*/

	IF M_RACE EQ 0 THEN RACEHISP_CAT = 5;
	ELSE IF M_HISP EQ 0 AND M_RACE EQ 1 THEN RACEHISP_CAT = 0; /*NH WHITE*/
	ELSE IF M_HISP EQ 0 AND M_RACE EQ 2 THEN RACEHISP_CAT = 1; /*NH BLLACK*/
	ELSE IF M_RACE GT 2 THEN RACEHISP_CAT = 2;
	ELSE IF M_HISP IN (1,2,3,4,5) THEN RACEHISP_CAT = 3; /*Hispanic*/
	ELSE IF M_HSIP GT 5 THEN RACEHISP_CAT = 4;


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

/*DELETING RACEETH_CAT 2, 4, 5 and just keeping black,white & hisp*/

	IF RACEHISP_CAT EQ 0 THEN RACEHISP = 0;/*NH WHITE*/
	ELSE IF RACEHISP_CAT EQ 1 THEN RACEHISP = 1; /*NH BLLACK*/
	ELSE IF RACEHISP_CAT EQ 3 THEN RACEHISP = 2; /*Hispanic*/
	ELSE DELETE;


RUN;

ODS TAGSETS.EXCELXP
file='C:\Users\njain\Documents\Personal\Dissertation\SGA\GESTBYFEMALE_GEN1.xls'
STYLE=minimal
OPTIONS ( Orientation = 'landscape'
FitToPage = 'yes'
Pages_FitWidth = '1'
Pages_FitHeight = '100' );
/*Calculating percentiles by gestational age and race
proc means data=CONVERTG1 mean median max std P10 P90; 
WHERE SAM_SEX = '2';
var BIRTHWT_F;
  class GEST_WK RACEHISP2;
FORMAT RACEHISP2 $RACEETH.;
run;
ods tagsets.excelxp close;*/
DATA CHAP1A;
	SET DT.FINALDATA_ANL;

	/*extremely preterm (<28 weeks)
very preterm (28 to <32 weeks)
moderate to late preterm (32 to <37 weeks).*/

	IF SAM_combgest_final < 20 | SAM_combgest_final > 47 THEN SAM_PTB4= 3;
	ELSE IF 20 < SAM_combgest_final <32 THEN SAM_PTB4 = 0;
	ELSE IF 32 <= SAM_combgest_final <37 THEN SAM_PTB4 = 1;
	ELSE IF 37 <= SAM_combgest_final <=47 THEN SAM_PTB4 = 2;

 /*Just to create PTB and non-PTB*/
	IF 20 < SAM_combgest_final < 38 THEN PTB_CAT0 = 1;
	ELSE IF 38 <= SAM_combgest_final <=47 THEN PTB_CAT0 = 0;

 /*Just to create PTB and non-PTB*/
	IF 20 < GEST_WK < 38 THEN PTB_CAT1 = 1;
	ELSE IF 38 <= GEST_WK <=47 THEN PTB_CAT1 = 0;

/* WEIGHT */
SAM_LBW= .;
  if '0' < SAM_WT < '2500' then SAM_LBW = 1;
  else if '2500' <= SAM_WT < '9999' then SAM_LBW = 0;  

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
  IF '0' <= SAM_EDUMOM < '12' THEN SAM_meduc = 1;
  else if SAM_EDUMOM eq '12' THEN SAM_meduc = 2; 
  else if '12' < SAM_EDUMOM <= '15' then SAM_meduc = 3;
  else if '15' < SAM_EDUMOM < '18' then SAM_meduc = 4;
  else SAM_meduc = 5;

 SAM_feduc3 = .;
  IF '0' <= SAM_EDUDAD < '12' THEN SAM_Feduc = 1;
  else if SAM_EDUDAD eq '12' THEN SAM_Feduc = 2; 
  else if '12' < SAM_EDUDAD <= '15' then SAM_Feduc = 3;
  else if '15' < SAM_EDUDAD < '18' then SAM_Feduc = 4;
  else SAM_Feduc = 5;

/* recode marital status */
SAM_married = .;
  if SAM_MARITAL = 1 then SAM_married = 1;
  else if SAM_MARITAL = 2 then SAM_married = 0;        
  else SAM_married = 2;

/* Preterm categories: early preterm (less than 34 weeks gestation), 
very preterm (34 to 36 weeks gestation), and  preterm (lt 37 weeks gestation)*/

    IF GEST_WK < 20 | GEST_WK > 47 THEN SAM_PTB3= 99;
	ELSE IF 20 < GEST_WK < 33 THEN SAM_PTB3 = 0;
	ELSE IF 33 <= GEST_WK <38 THEN SAM_PTB3 = 1;
	ELSE IF 38 <= GEST_WK <=47 THEN SAM_PTB3 = 2;

/* recode race */
SAM_LBW= .;
  if '0' < SAM_WT < '2500' then SAM_LBW = 1;
  else if '2500' <= SAM_WT < '9999' then SAM_LBW = 0;  

/* recode marital status */
SAM_married = .;
  if SAM_MARITAL = 1 then SAM_married = 1;
  else if SAM_MARITAL = 2 then SAM_married = 0;        

/*FOREIGN BORN*/

  IF '00' <= SAM_BIRPLMOM < '52' THEN FOREIGN = 0;
  ELSE IF '52' <= SAM_BIRPLMOM < '99' THEN FOREIGN = 1;


/* code Kessner's Index of adequacy of prenatal care */
  /* note this is modified - it does not account for
     the place of delivery (private obstetrical service req'd
     for adequate care) */

SAM_Kessner = 2;
  if GEST_WK=99 or GEST_WK=. or SAM_PNC=. or SAM_PNCVST_TOTAL=. then SAM_Kessner = 4;
  else if (SAM_PNC > 6) or
    ((14 <= GEST_WK <= 21) and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL = 0 or SAM_PNC=.)) or
    ((22 <= GEST_WK <= 29) and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL <= 1)) or
    ((30 <= GEST_WK <= 31) and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL <= 2)) or
    ((32 <= GEST_WK <= 33) and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL <= 3)) or
    (GEST_WK >= 34 and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL <= 4)) then SAM_Kessner = 3;
  else if (SAM_PNC <= 3) and
    (GEST_WK <= 13 and (SAM_PNCVST_TOTAL = . or SAM_PNCVST_TOTAL >= 1)) or
    ((14 <= GEST_WK <= 17) and SAM_PNCVST_TOTAL >= 2) or
    ((18 <= GEST_WK <= 21) and SAM_PNCVST_TOTAL >= 3) or
    ((22 <= GEST_WK <= 25) and SAM_PNCVST_TOTAL >= 4) or
    ((26 <= GEST_WK <= 29) and SAM_PNCVST_TOTAL >= 5) or
    ((30 <= GEST_WK <= 31) and SAM_PNCVST_TOTAL >= 6) or
    ((32 <= GEST_WK <= 33) and SAM_PNCVST_TOTAL >= 7) or
    ((34 <= GEST_WK <= 35) and SAM_PNCVST_TOTAL >= 8) or
    (GEST_WK >= 36 and SAM_PNCVST_TOTAL >= 9) then SAM_Kessner = 1;  

/***********For generation 1 - Females, the standards are from Generation 2**********/

SGA_wfg1= '0' ;

if (GEST_WK le 22 and sex = '2' and racehisp = '0' and BIRTHWT_F le 282)                                  then SGA_wfg1='2' ;
else if (GEST_WK le 22 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 283 and BIRTHWT_F le 3197))    then SGA_wfg1='1' ;
else if (GEST_WK le 22 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3197)                            then SGA_wfg1='3' ;

else if (GEST_WK=23 and sex = '2' and racehisp = '0' and BIRTHWT_F le 512)                                then SGA_wfg1='2' ;
else if (GEST_WK=23 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 513 and BIRTHWT_F le 3150))       then SGA_wfg1='1' ;
else if (GEST_WK=23 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3150)                               then SGA_wfg1='3' ;

else if (GEST_WK=24 and sex = '2' and racehisp = '0' and BIRTHWT_F le 481)                                then SGA_wfg1='2' ;
else if (GEST_WK=24 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 482 and BIRTHWT_F le 3884))       then SGA_wfg1='1' ;
else if (GEST_WK=24 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3884)                               then SGA_wfg1='3' ;

else if (GEST_WK=25 and sex = '2' and racehisp = '0' and BIRTHWT_F le 549)                                then SGA_wfg1='2' ;
else if (GEST_WK=25 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 550 and BIRTHWT_F le 3260))       then SGA_wfg1='1' ;
else if (GEST_WK=25 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3260)                               then SGA_wfg1='3' ;

else if (GEST_WK=26 and sex = '2' and racehisp = '0' and BIRTHWT_F le 559)                                then SGA_wfg1='2' ;
else if (GEST_WK=26 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 560 and BIRTHWT_F le 3520))       then SGA_wfg1='1' ;
else if (GEST_WK=26 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3520)                               then SGA_wfg1='3' ;

else if (GEST_WK=27 and sex = '2' and racehisp = '0' and BIRTHWT_F le 650)                                then SGA_wfg1='2' ;
else if (GEST_WK=27 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 651 and BIRTHWT_F le 3425))       then SGA_wfg1='1' ;
else if (GEST_WK=27 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3425)                               then SGA_wfg1='3' ;

else if (GEST_WK=28 and sex = '2' and racehisp = '0' and BIRTHWT_F le 679)                                then SGA_wfg1='2' ;
else if (GEST_WK=28 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 680 and BIRTHWT_F le 3350))       then SGA_wfg1='1' ;
else if (GEST_WK=28 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3350)                               then SGA_wfg1='3' ;

else if (GEST_WK=29 and sex = '2' and racehisp = '0' and BIRTHWT_F le 940)                                then SGA_wfg1='2' ;
else if (GEST_WK=29 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 941 and BIRTHWT_F le 3208))       then SGA_wfg1='1' ;
else if (GEST_WK=29 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3208)                               then SGA_wfg1='3' ;

else if (GEST_WK=30 and sex = '2' and racehisp = '0' and BIRTHWT_F le 840)                                then SGA_wfg1='2' ;
else if (GEST_WK=30 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 841 and BIRTHWT_F le 3596))       then SGA_wfg1='1' ;
else if (GEST_WK=30 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3596)                               then SGA_wfg1='3' ;

else if (GEST_WK=31 and sex = '2' and racehisp = '0' and BIRTHWT_F le 1194)                               then SGA_wfg1='2' ;
else if (GEST_WK=31 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 1195 and BIRTHWT_F le 3440))      then SGA_wfg1='1' ;
else if (GEST_WK=31 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3440)                               then SGA_wfg1='3' ;

else if (GEST_WK=32 and sex = '2' and racehisp = '0' and BIRTHWT_F le 1331)                               then SGA_wfg1='2' ;
else if (GEST_WK=32 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 1332 and BIRTHWT_F le 3487))      then SGA_wfg1='1' ;
else if (GEST_WK=32 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3487)                               then SGA_wfg1='3' ;

else if (GEST_WK=33 and sex = '2' and racehisp = '0' and BIRTHWT_F le 1589)                               then SGA_wfg1='2' ;
else if (GEST_WK=33 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 1590 and BIRTHWT_F le 3406))      then SGA_wfg1='1' ;
else if (GEST_WK=33 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3406)                               then SGA_wfg1='3' ;

else if (GEST_WK=34 and sex = '2' and racehisp = '0' and BIRTHWT_F le 1672)                               then SGA_wfg1='2' ;
else if (GEST_WK=34 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 1673 and BIRTHWT_F le 3430))      then SGA_wfg1='1' ;
else if (GEST_WK=34 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3430)                               then SGA_wfg1='3' ;

else if (GEST_WK=35 and sex = '2' and racehisp = '0' and BIRTHWT_F le 1891)                               then SGA_wfg1='2' ;
else if (GEST_WK=35 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 1892 and BIRTHWT_F le 3447))      then SGA_wfg1='1' ;
else if (GEST_WK=35 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3447)                               then SGA_wfg1='3' ;

else if (GEST_WK=36 and sex = '2' and racehisp = '0' and BIRTHWT_F le 2114)                               then SGA_wfg1='2' ;
else if (GEST_WK=36 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 2115 and BIRTHWT_F le 3499))      then SGA_wfg1='1' ;
else if (GEST_WK=36 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3500)                               then SGA_wfg1='3' ;

else if (GEST_WK=37 and sex = '2' and racehisp = '0' and BIRTHWT_F le 2334)                               then SGA_wfg1='5' ;
else if (GEST_WK=37 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 2335 and BIRTHWT_F le 3600))      then SGA_wfg1='4' ;
else if (GEST_WK=37 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3600)                               then SGA_wfg1='6' ;

else if (GEST_WK=38 and sex = '2' and racehisp = '0' and BIRTHWT_F le 2589)                               then SGA_wfg1='5' ;
else if (GEST_WK=38 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 2590 and BIRTHWT_F le 3710))      then SGA_wfg1='4' ;
else if (GEST_WK=38 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3710)                               then SGA_wfg1='6' ;

else if (GEST_WK=39 and sex = '2' and racehisp = '0' and BIRTHWT_F le 2804)                               then SGA_wfg1='5' ;
else if (GEST_WK=39 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 2805 and BIRTHWT_F le 3881))      then SGA_wfg1='4' ;
else if (GEST_WK=39 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3881)                               then SGA_wfg1='6' ;

else if (GEST_WK=40 and sex = '2' and racehisp = '0' and BIRTHWT_F le 2899)                               then SGA_wfg1='5' ;
else if (GEST_WK=40 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 2900 and BIRTHWT_F le 3941))      then SGA_wfg1='4' ;
else if (GEST_WK=40 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3941)                               then SGA_wfg1='6' ;

else if (GEST_WK=41 and sex = '2' and racehisp = '0' and BIRTHWT_F le 2949)                               then SGA_wfg1='5' ;
else if (GEST_WK=41 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 2950 and BIRTHWT_F le 4000))      then SGA_wfg1='4' ;
else if (GEST_WK=41 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 4000)                               then SGA_wfg1='6' ;

else if (GEST_WK=42 and sex = '2' and racehisp = '0' and BIRTHWT_F le 2914)                               then SGA_wfg1='8' ;
else if (GEST_WK=42 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 2915 and BIRTHWT_F le 3997))      then SGA_wfg1='7' ;
else if (GEST_WK=42 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3997)                               then SGA_wfg1='9' ;

else if (GEST_WK=43 and sex = '2' and racehisp = '0' and BIRTHWT_F le 2806)                               then SGA_wfg1='8' ;
else if (GEST_WK=43 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 2807 and BIRTHWT_F le 4054))      then SGA_wfg1='7' ;
else if (GEST_WK=43 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 4054)                               then SGA_wfg1='9' ;

else if (GEST_WK=44 and sex = '2' and racehisp = '0' and BIRTHWT_F le 2852)                               then SGA_wfg1='8' ;
else if (GEST_WK=44 and sex = '2' and racehisp = '0' and (BIRTHWT_F ge 2853 and BIRTHWT_F le 3960))      then SGA_wfg1='7' ;
else if (GEST_WK=44 and sex = '2' and racehisp = '0' and BIRTHWT_F gt 3960)                               then SGA_wfg1='9' ;


if GEST_WK = . then SGA_wfg1 = '0';
if BIRTHWT_F= . then SGA_wfg1 = '0';
if (GEST_WK < 20 or GEST_WK > 50) then SGA_wfg1 = '0';
if (BIRTHWT_F< 300 or BIRTHWT_F> 9000) then SGA_wfg1 = '0';


SGA_bfg1= '0' ;

if (GEST_WK le 22 and sex = '2' and racehisp = '1' and BIRTHWT_F le 349)                                      then SGA_bfg1='2' ;
else if (GEST_WK le 22 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 350 and BIRTHWT_F le 2696))    then SGA_bfg1='1' ;
else if (GEST_WK le 22 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 2696)                            then SGA_bfg1='3' ;

else if (GEST_WK=23 and sex = '2' and racehisp = '1' and BIRTHWT_F le 392)                                then SGA_bfg1='2' ;
else if (GEST_WK=23 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 393 and BIRTHWT_F le 2840))       then SGA_bfg1='1' ;
else if (GEST_WK=23 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 2840)                               then SGA_bfg1='3' ;

else if (GEST_WK=24 and sex = '2' and racehisp = '1' and BIRTHWT_F le 522)                                then SGA_bfg1='2' ;
else if (GEST_WK=24 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 523 and BIRTHWT_F le 3367))       then SGA_bfg1='1' ;
else if (GEST_WK=24 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3367)                               then SGA_bfg1='3' ;

else if (GEST_WK=25 and sex = '2' and racehisp = '1' and BIRTHWT_F le 430)                                then SGA_bfg1='2' ;
else if (GEST_WK=25 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 431 and BIRTHWT_F le 1660))       then SGA_bfg1='1' ;
else if (GEST_WK=25 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 1660)                               then SGA_bfg1='3' ;

else if (GEST_WK=26 and sex = '2' and racehisp = '1' and BIRTHWT_F le 542)                                then SGA_bfg1='2' ;
else if (GEST_WK=26 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 543 and BIRTHWT_F le 3075))       then SGA_bfg1='1' ;
else if (GEST_WK=26 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3075)                               then SGA_bfg1='3' ;

else if (GEST_WK=27 and sex = '2' and racehisp = '1' and BIRTHWT_F le 673)                                then SGA_bfg1='2' ;
else if (GEST_WK=27 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 674 and BIRTHWT_F le 3714))       then SGA_bfg1='1' ;
else if (GEST_WK=27 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3714)                               then SGA_bfg1='3' ;

else if (GEST_WK=28 and sex = '2' and racehisp = '1' and BIRTHWT_F le 665)                                then SGA_bfg1='2' ;
else if (GEST_WK=28 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 666 and BIRTHWT_F le 3033))       then SGA_bfg1='1' ;
else if (GEST_WK=28 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3033)                               then SGA_bfg1='3' ;

else if (GEST_WK=29 and sex = '2' and racehisp = '1' and BIRTHWT_F le 1009)                               then SGA_bfg1='2' ;
else if (GEST_WK=29 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 1010 and BIRTHWT_F le 3505))      then SGA_bfg1='1' ;
else if (GEST_WK=29 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3505)                               then SGA_bfg1='3' ;

else if (GEST_WK=30 and sex = '2' and racehisp = '1' and BIRTHWT_F le 894)                                then SGA_bfg1='2' ;
else if (GEST_WK=30 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 895 and BIRTHWT_F le 3281))       then SGA_bfg1='1' ;
else if (GEST_WK=30 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3281)                               then SGA_bfg1='3' ;

else if (GEST_WK=31 and sex = '2' and racehisp = '1' and BIRTHWT_F le 1094)                               then SGA_bfg1='2' ;
else if (GEST_WK=31 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 1095 and BIRTHWT_F le 3005))      then SGA_bfg1='1' ;
else if (GEST_WK=31 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3005)                               then SGA_bfg1='3' ;

else if (GEST_WK=32 and sex = '2' and racehisp = '1' and BIRTHWT_F le 1374)                               then SGA_bfg1='2' ;
else if (GEST_WK=32 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 1375 and BIRTHWT_F le 3455))      then SGA_bfg1='1' ;
else if (GEST_WK=32 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3455)                               then SGA_bfg1='3' ;

else if (GEST_WK=33 and sex = '2' and racehisp = '1' and BIRTHWT_F le 1439)                               then SGA_bfg1='2' ;
else if (GEST_WK=33 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 1440 and BIRTHWT_F le 3346))      then SGA_bfg1='1' ;
else if (GEST_WK=33 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3346)                               then SGA_bfg1='3' ;

else if (GEST_WK=34 and sex = '2' and racehisp = '1' and BIRTHWT_F le 1784)                               then SGA_bfg1='2' ;
else if (GEST_WK=34 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 1785 and BIRTHWT_F le 3440))      then SGA_bfg1='1' ;
else if (GEST_WK=34 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3440)                               then SGA_bfg1='3' ;

else if (GEST_WK=35 and sex = '2' and racehisp = '1' and BIRTHWT_F le 1849)                               then SGA_bfg1='2' ;
else if (GEST_WK=35 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 1850 and BIRTHWT_F le 3410))      then SGA_bfg1='1' ;
else if (GEST_WK=35 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3410)                               then SGA_bfg1='3' ;

else if (GEST_WK=36 and sex = '2' and racehisp = '1' and BIRTHWT_F le 2100)                               then SGA_bfg1='2' ;
else if (GEST_WK=36 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 2101 and BIRTHWT_F le 3400))      then SGA_bfg1='1' ;
else if (GEST_WK=36 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3400)                               then SGA_bfg1='3' ;

else if (GEST_WK=37 and sex = '2' and racehisp = '1' and BIRTHWT_F le 2267)                               then SGA_bfg1='5' ;
else if (GEST_WK=37 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 2268 and BIRTHWT_F le 3420))      then SGA_bfg1='4' ;
else if (GEST_WK=37 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3420)                               then SGA_bfg1='6' ;

else if (GEST_WK=38 and sex = '2' and racehisp = '1' and BIRTHWT_F le 2494)                               then SGA_bfg1='5' ;
else if (GEST_WK=38 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 2495 and BIRTHWT_F le 3610))      then SGA_bfg1='4' ;
else if (GEST_WK=38 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3610)                               then SGA_bfg1='6' ;

else if (GEST_WK=39 and sex = '2' and racehisp = '1' and BIRTHWT_F le 2619)                               then SGA_bfg1='5' ;
else if (GEST_WK=39 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 2620 and BIRTHWT_F le 3700))      then SGA_bfg1='4' ;
else if (GEST_WK=39 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3700)                               then SGA_bfg1='6' ;

else if (GEST_WK=40 and sex = '2' and racehisp = '1' and BIRTHWT_F le 2708)                               then SGA_bfg1='5' ;
else if (GEST_WK=40 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 2709 and BIRTHWT_F le 3790))      then SGA_bfg1='4' ;
else if (GEST_WK=40 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3790)                               then SGA_bfg1='6' ;

else if (GEST_WK=41 and sex = '2' and racehisp = '1' and BIRTHWT_F le 2729)                               then SGA_bfg1='5' ;
else if (GEST_WK=41 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 2730 and BIRTHWT_F le 3855))      then SGA_bfg1='4' ;
else if (GEST_WK=41 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3855)                               then SGA_bfg1='6' ;

else if (GEST_WK=42 and sex = '2' and racehisp = '1' and BIRTHWT_F le 2729)                               then SGA_bfg1='8' ;
else if (GEST_WK=42 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 2730 and BIRTHWT_F le 3828))      then SGA_bfg1='7' ;
else if (GEST_WK=42 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3828)                               then SGA_bfg1='9' ;

else if (GEST_WK=43 and sex = '2' and racehisp = '1' and BIRTHWT_F le 2649)                               then SGA_bfg1='8' ;
else if (GEST_WK=43 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 2650 and BIRTHWT_F le 3780))      then SGA_bfg1='7' ;
else if (GEST_WK=43 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3780)                               then SGA_bfg1='9' ;

else if (GEST_WK=44 and sex = '2' and racehisp = '1' and BIRTHWT_F le 2730)                               then SGA_bfg1='8' ;
else if (GEST_WK=44 and sex = '2' and racehisp = '1' and (BIRTHWT_F ge 2731 and BIRTHWT_F le 3858))      then SGA_bfg1='7' ;
else if (GEST_WK=44 and sex = '2' and racehisp = '1' and BIRTHWT_F gt 3858)                               then SGA_bfg1='9' ;


if GEST_WK = . then SGA_bfg1 = '0';
if BIRTHWT_F= . then SGA_bfg1 = '0';
if (GEST_WK < 20 or GEST_WK > 50) then SGA_bfg1 = '0';
if (BIRTHWT_F< 300 or BIRTHWT_F> 9000) then SGA_bfg1 = '0';

SGA_hfg1= '0' ;

if (GEST_WK=23 and sex = '2' and racehisp = '2' and BIRTHWT_F le 311)                                     then SGA_hfg1='2' ;
else if (GEST_WK=23 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 312 and BIRTHWT_F le 2958))       then SGA_hfg1='1' ;
else if (GEST_WK=23 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 2958)                               then SGA_hfg1='3' ;

else if (GEST_WK=24 and sex = '2' and racehisp = '2' and BIRTHWT_F le 386)                                then SGA_hfg1='2' ;
else if (GEST_WK=24 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 387 and BIRTHWT_F le 3360))       then SGA_hfg1='1' ;
else if (GEST_WK=24 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3360)                               then SGA_hfg1='3' ;

else if (GEST_WK=25 and sex = '2' and racehisp = '2' and BIRTHWT_F le 429)                                then SGA_hfg1='2' ;
else if (GEST_WK=25 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 430 and BIRTHWT_F le 798))        then SGA_hfg1='1' ;
else if (GEST_WK=25 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 798)                                then SGA_hfg1='3' ;

else if (GEST_WK=26 and sex = '2' and racehisp = '2' and BIRTHWT_F le 413)                                then SGA_hfg1='2' ;
else if (GEST_WK=26 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 414 and BIRTHWT_F le 3225))       then SGA_hfg1='1' ;
else if (GEST_WK=26 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3225)                               then SGA_hfg1='3' ;

else if (GEST_WK=27 and sex = '2' and racehisp = '2' and BIRTHWT_F le 489)                                then SGA_hfg1='2' ;
else if (GEST_WK=27 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 490 and BIRTHWT_F le 2653))       then SGA_hfg1='1' ;
else if (GEST_WK=27 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 2653)                               then SGA_hfg1='3' ;

else if (GEST_WK=28 and sex = '2' and racehisp = '2' and BIRTHWT_F le 764)                                then SGA_hfg1='2' ;
else if (GEST_WK=28 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 765 and BIRTHWT_F le 3578))       then SGA_hfg1='1' ;
else if (GEST_WK=28 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3578)                               then SGA_hfg1='3' ;

else if (GEST_WK=29 and sex = '2' and racehisp = '2' and BIRTHWT_F le 994)                                then SGA_hfg1='2' ;
else if (GEST_WK=29 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 995 and BIRTHWT_F le 3770))       then SGA_hfg1='1' ;
else if (GEST_WK=29 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3770)                               then SGA_hfg1='3' ;

else if (GEST_WK=30 and sex = '2' and racehisp = '2' and BIRTHWT_F le 972)                                then SGA_hfg1='2' ;
else if (GEST_WK=30 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 973 and BIRTHWT_F le 3203))       then SGA_hfg1='1' ;
else if (GEST_WK=30 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3203)                               then SGA_hfg1='3' ;

else if (GEST_WK=31 and sex = '2' and racehisp = '2' and BIRTHWT_F le 1099)                               then SGA_hfg1='2' ;
else if (GEST_WK=31 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 1100 and BIRTHWT_F le 3295))      then SGA_hfg1='1' ;
else if (GEST_WK=31 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3295)                               then SGA_hfg1='3' ;

else if (GEST_WK=32 and sex = '2' and racehisp = '2' and BIRTHWT_F le 1374)                               then SGA_hfg1='2' ;
else if (GEST_WK=32 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 1375 and BIRTHWT_F le 3560))      then SGA_hfg1='1' ;
else if (GEST_WK=32 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3560)                               then SGA_hfg1='3' ;

else if (GEST_WK=33 and sex = '2' and racehisp = '2' and BIRTHWT_F le 1284)                               then SGA_hfg1='2' ;
else if (GEST_WK=33 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 1285 and BIRTHWT_F le 3480))      then SGA_hfg1='1' ;
else if (GEST_WK=33 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3480)                               then SGA_hfg1='3' ;

else if (GEST_WK=34 and sex = '2' and racehisp = '2' and BIRTHWT_F le 1789)                               then SGA_hfg1='2' ;
else if (GEST_WK=34 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 1790 and BIRTHWT_F le 3540))      then SGA_hfg1='1' ;
else if (GEST_WK=34 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3540)                               then SGA_hfg1='3' ;

else if (GEST_WK=35 and sex = '2' and racehisp = '2' and BIRTHWT_F le 1829)                               then SGA_hfg1='2' ;
else if (GEST_WK=35 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 1830 and BIRTHWT_F le 3402))      then SGA_hfg1='1' ;
else if (GEST_WK=35 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3402)                               then SGA_hfg1='3' ;

else if (GEST_WK=36 and sex = '2' and racehisp = '2' and BIRTHWT_F le 2159)                               then SGA_hfg1='2' ;
else if (GEST_WK=36 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 2160 and BIRTHWT_F le 3487))      then SGA_hfg1='1' ;
else if (GEST_WK=36 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3487)                               then SGA_hfg1='3' ;

else if (GEST_WK=37 and sex = '2' and racehisp = '2' and BIRTHWT_F le 2380)                               then SGA_hfg1='5' ;
else if (GEST_WK=37 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 2381 and BIRTHWT_F le 3581))      then SGA_hfg1='4' ;
else if (GEST_WK=37 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3581)                               then SGA_hfg1='6' ;

else if (GEST_WK=38 and sex = '2' and racehisp = '2' and BIRTHWT_F le 2534)                               then SGA_hfg1='5' ;
else if (GEST_WK=38 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 2535 and BIRTHWT_F le 3615))      then SGA_hfg1='4' ;
else if (GEST_WK=38 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3615)                               then SGA_hfg1='6' ;

else if (GEST_WK=39 and sex = '2' and racehisp = '2' and BIRTHWT_F le 2734)                               then SGA_hfg1='5' ;
else if (GEST_WK=39 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 2735 and BIRTHWT_F le 3912))      then SGA_hfg1='4' ;
else if (GEST_WK=39 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3912)                               then SGA_hfg1='6' ;

else if (GEST_WK=40 and sex = '2' and racehisp = '2' and BIRTHWT_F le 2829)                               then SGA_hfg1='5' ;
else if (GEST_WK=40 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 2830 and BIRTHWT_F le 3860))      then SGA_hfg1='4' ;
else if (GEST_WK=40 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3860)                               then SGA_hfg1='6' ;

else if (GEST_WK=41 and sex = '2' and racehisp = '2' and BIRTHWT_F le 2839)                               then SGA_hfg1='5' ;
else if (GEST_WK=41 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 2840 and BIRTHWT_F le 3940))      then SGA_hfg1='4' ;
else if (GEST_WK=41 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3940)                               then SGA_hfg1='6' ;

else if (GEST_WK=42 and sex = '2' and racehisp = '2' and BIRTHWT_F le 2800)                               then SGA_hfg1='8' ;
else if (GEST_WK=42 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 2801 and BIRTHWT_F le 3921))      then SGA_hfg1='7' ;
else if (GEST_WK=42 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3921)                               then SGA_hfg1='9' ;

else if (GEST_WK=43 and sex = '2' and racehisp = '2' and BIRTHWT_F le 2687)                               then SGA_hfg1='8' ;
else if (GEST_WK=43 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 2688 and BIRTHWT_F le 3900))      then SGA_hfg1='7' ;
else if (GEST_WK=43 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3900)                               then SGA_hfg1='9' ;

else if (GEST_WK=44 and sex = '2' and racehisp = '2' and BIRTHWT_F le 2794)                               then SGA_hfg1='8' ;
else if (GEST_WK=44 and sex = '2' and racehisp = '2' and (BIRTHWT_F ge 2795 and BIRTHWT_F le 3997))      then SGA_hfg1='7' ;
else if (GEST_WK=44 and sex = '2' and racehisp = '2' and BIRTHWT_F gt 3997)                               then SGA_hfg1='9' ;


if GEST_WK = . then SGA_hfg1= '0';
if BIRTHWT_F= . then SGA_hfg1= '0';
if (GEST_WK < 20 or GEST_WK > 50) then SGA_hfg1= '0';
if (BIRTHWT_F< 300 or BIRTHWT_F> 9000) then SGA_hfg1= '0';

RUN;
data livefnh1;
set CHAP1A;

IF SGA_wfg1 in (2, 5, 8) THEN SGA_WNHF_G1 = 1;/*SGA*/
ELSE IF SGA_wfg1 in (1, 3, 4, 6, 7, 9) THEN SGA_WNHF_G1 = 0; /*ACCEPTABLE (APPROPRIATE) */

IF SGA_bfg1 in (2, 5, 8) THEN SGA_BNHFG1 = 1;/*SGA*/
ELSE IF SGA_bfg1 in (1, 3, 4, 6, 7, 9) THEN SGA_BNHFG1 = 0; /*ACCEPTABLE (APPROPRIATE) */

IF SGA_hfg1 in (2, 5, 8) THEN SGA_NHFG1 = 1;/*SGA*/
ELSE IF SGA_hfg1 in (1, 3, 4, 6, 7, 9) THEN SGA_NHFG1 = 0; /*ACCEPTABLE (APPROPRIATE) */

RUN;
/*overall except for SGA*/
PROC FREQ DATA = livefnh1;
TABLES RACEHISP;
*tables RACEHISP*PTB_CAT0;
*tables PTB_CAT1 PTB_CAT0;
RUN;
/*overall except for SGA - TABLE 1*/
PROC FREQ DATA = livefnh1;
TABLES (SAM_MAGE3 SAM_meduc SAM_feduc SAM_PTB4 SAM_LBW SAM_Kessner SAM_married SGA_WNHF_G1 SGA_BNHFG1 SGA_NHFG1)*RACEHISP;
RUN;
/*we do freq by ptb_Cat*mat_meduc3, since we want col percent that tell the rate of the mothers that
preterm that had certain education level or other characteristics; if we do it other way we need to look at row percent*/

/*BY RACE & ETHNICITY TABLE 1*/

/**WNH*/
PROC FREQ DATA = livefnh1;
TABLES RACEHISP * (SAM_MAGE3 SAM_meduc SAM_Feduc);
RUN;
PROC FREQ DATA = livefnh1;
TABLES (PTB_CAT4)*RACEHISP;
TITLE "Preterm births by race among women delivering between 1979-1983";
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_LBW)*RACEHISP;
TITLE "Low birthweight by race among women delivering between 1979-1983";
RUN;
PROC FREQ DATA = livefnh1;
TABLES SAM_MAGE3*RACEHISP;
TITLE "Materanl age by race among women delivering between 1979-1983";
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_Kessner)*RACEHISP;
TITLE "Kessner's Index of adequacy of prenatal care by race among women delivering between 1979-1983";
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_meduc)*RACEHISP;
TITLE "Materanl education by race among women delivering between 1979-1983";
RUN;
PROC FREQ DATA = livefnh1;
TABLES (foreign)*RACEHISP;
TITLE "Materanl MARITAL by race among women delivering between 1979-1983";
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_marital)*RACEHISP;
TITLE "Materanl MARITAL by race among women delivering between 1979-1983";
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_Feduc)*RACEHISP;
TITLE "Materanl education by race among women delivering between 1979-1983";
RUN;
PROC FREQ DATA = livefnh1;
TABLES (sam_sex)*RACEHISP;
TITLE "Materanl education by race among women delivering between 1999-2011";
RUN;
PROC FREQ DATA = livefnh1;
TABLES (SAM_PTB3)*RACEHISP;
TITLE "Preterm births by race among women delivering between 1979-1983";
RUN;


