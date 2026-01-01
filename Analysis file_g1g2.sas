/*****************************************************
PURPOSE: To do the descritptive analysis for generation 1, 1979-1983
We will do this analysis by race, preterm category and education
DATA: 3/31/16 
We also have deleted all the dates that have missing month - 2314 records;
Days+month = 32111
******************************************************/
libname DT 'C:\Users\njain\Documents\Personal\Dissertation\Final data creation\Final_data\Final_deidentified data';
LIBNAME VA 'C:\Users\njain\Documents\Personal\Dissertation\Final data creation\Matching data\Matching_762015';
LIBNAME PT 'C:\Users\NJain\Documents\Personal\PTB\04_DATA';

DATA CHAP1;
	SET DT.ANALYDATA;
	dates_char = put(imputed_date,mmddYY10.);
	S_Mm = input(substr(dates_char,1,2),8.);
    S_Dd = input(substr(dates_char,4,2),8.);
    S_Yy = input(substr(dates_char,7,4),8.); 
    M_Mm = input(substr(MDOB,1,2),8.);
    M_Dd = input(substr(MDOB,3,2),8.);
    M_Yy = input(substr(MDOB,5,4),8.); 
	SAMBWT = input(SAM_WT,comma9.);
	MATBWT =input(BWT,comma9.);
	GEST_WKG2=put(MAT_COMBGEST,4.0);

RUN;

/*THIS DATASET SHOULD BE USED FOR BOTH THE ANALYSIS*/
DATA CHAP2;
	SET CHAP1;
	/* convert numeric to character */
	GEST_WKG1=put(SAM_combgest_final,4.0);

/*using the MDY function, create the SAS date-these can be used in INTCK function later to calculate time intervals*/
    SAM_Var = MDY(S_Mm,S_Dd,S_Yy); *Sample moms LMP;
	MOM_VAR = MDY(M_Mm,M_Dd,M_Yy); *Samples DOB;
	M_HISP1 = put (M_HISP,2.0);
    M_RACE1 = put (M_RACE,2.0);

RUN;
DATA CHAP3;
	SET CHAP2;

/*Calculating weejs for PTB*/
	SAM_combgest_final = intck('week', SAM_VAR, MOM_Var);

/*Categorizing ethnicity*/
	IF M_HISP1 EQ 0 AND M_RACE1 EQ 1 THEN RACEHISP = 0; /*NH WHITE*/
	ELSE IF M_HISP1 EQ 0 AND M_RACE1 EQ 2 THEN RACEHISP = 1; /*NH BLLACK*/
	ELSE IF M_HISP1 IN (1,2,3,4,5) THEN RACEHISP = 2; /*Hispanic*/
	ELSE delete; 

RUN;
DATA PT.FINALDATA_G1G2;
	set chap3;

/*FOR GRANDMOTHER*/
IF SAMBWT <500 THEN DELETE;
IF SAM_combgest_final <=20  THEN DELETE;
if SAM_combgest_final >47 THEN DELETE;

/*FOR MOTHER*/
IF MATBWT <500 THEN DELETE;
IF MAT_COMBGEST <=20 THEN DELETE;
IF MAT_COMBGEST >47 THEN DELETE;

run;

PROC freq DATA = PT.FINALDATA_G1G2;
tables SAM_combgest_final MAT_COMBGEST;
run;


PT.FINALDATA_G1G2;
TABLES SAM_combgest_final GEST_WKG2 SAMBWT MATBWT M_HISP1 M_RACE1 RACEHISP;
RUN;

