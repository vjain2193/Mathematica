/*****************************************************
PURPOSE: TO CHECK AVERAGE BWT IN EACH PRETERM CATEGORY
Adapted from Checksondata_30916.sas for the Jenner compatibility bundle:
the original LIBNAME VA pointed at the author's local dissertation data
(C:\Users\njain\...\Matching_762015); here VA.finalrecode_link is a small
mock cohort with the same columns (SAM_WT, BWT, SAM_COMBGEST, MAT_COMBGEST,
M_HISP, M_RACE) built inline. The PTB categorization, race/ethnicity
recoding, and PROC SORT / PROC MEANS / PROC FREQ steps below are otherwise
untouched.
******************************************************/

libname VA (work);

data VA.finalrecode_link;
  input SAM_WT BWT SAM_COMBGEST MAT_COMBGEST M_HISP M_RACE;
  datalines;
2600 3100 26 27 0 1
3400 3300 39 40 0 1
1900 2000 22 23 1 2
3100 3200 36 37 0 2
2800 2950 32 33 2 3
3600 3550 41 41 0 1
2400 2500 30 31 1 4
3300 3250 38 39 0 1
2000 2100 24 25 3 5
3500 3450 40 39 0 2
2700 2650 33 34 0 2
3200 3150 37 38 1 1
2500 2450 29 30 0 1
3450 3400 40 41 4 3
1800 1900 21 22 5 2
3050 3000 35 36 0 1
2200 2250 27 28 1 3
3700 3650 42 42 0 1
2900 2850 34 35 0 2
3150 3100 36 37 1 4
;
run;

/**For Cohort 1: 1979-1983**/

DATA link_table1;
	SET VA.finalrecode_link;
	SAMBWT =input(SAM_WT,comma9.);
	MATBWT =input(BWT,comma9.);
	/* Preterm categories: early preterm (less than 34 weeks gestation),
very preterm (34 to 36 weeks gestation), and  preterm (lt 37 weeks gestation)*/

/*extremely preterm (<28 weeks)
very preterm (28 to <32 weeks)
moderate to late preterm (32 to <37 weeks).*/

    IF SAM_COMBGEST < 20 | SAM_COMBGEST > 47 THEN SAM_PTB= 99;
	ELSE IF 20 < SAM_combgest < 24 THEN SAM_PTB = 0;  *20-23;
	ELSE IF 24 < SAM_combgest < 28 THEN SAM_PTB = 1;  *24-27;
	ELSE IF 28 <= SAM_combgest <31 THEN SAM_PTB = 2;  *28-30;
	ELSE IF 31 <= SAM_combgest <33 THEN SAM_PTB = 3;  *31-32;
	ELSE IF 33 <= SAM_combgest <35 THEN SAM_PTB = 4;  *33-34;
	ELSE IF 35 <= SAM_combgest <37 THEN SAM_PTB = 5;  *35-36;
	ELSE IF 37 <= SAM_combgest <=47 THEN SAM_PTB = 6; *37+;

	IF MAT_COMBGEST < 20 | MAT_COMBGEST > 47 THEN MAT_PTB= 99;  /**Using regular LPM from G2**/
	ELSE IF 20 < MAT_COMBGEST < 24 THEN MAT_PTB = 0;  *20-23;
	ELSE IF 24 < MAT_COMBGEST < 28 THEN MAT_PTB = 1;  *24-27;
	ELSE IF 28 <= MAT_COMBGEST <31 THEN MAT_PTB = 2;  *28-30;
	ELSE IF 31 <= MAT_COMBGEST <33 THEN MAT_PTB = 3;  *31-32;
	ELSE IF 33 <= MAT_COMBGEST <35 THEN MAT_PTB = 4;  *33-34;
	ELSE IF 35 <= MAT_COMBGEST <37 THEN MAT_PTB = 5;  *35-36;
	ELSE IF 37 <= MAT_COMBGEST <=47 THEN MAT_PTB = 6; *37+;

MAT_race = .;
  if M_RACE EQ '1' then MAT_MRACE = 1; /* White */
  else if M_RACE = '2' then MAT_MRACE = 2; /* Black */
  else MAT_MRACE = 3;  /* NH other */

	IF M_HISP EQ 0 AND M_RACE EQ 1 THEN RACEHISP = 0; /*NH WHITE*/
	ELSE IF M_HISP EQ 0 AND M_RACE EQ 2 THEN RACEHISP = 1; /*NH BLLACK*/
	ELSE IF M_HISP IN (1,2,3,4,5) THEN RACEHISP = 2; /*Hispanic*/
	ELSE RACEHISP = 3;

/* WEIGHT */
SAM_LBW= .;
  if '0' < SAM_WT < '2500' then SAM_LBW = 1;
  else if '2500' <= SAM_WT < '9999' then SAM_LBW = 0;

 MAT_LBW= .;
  if '0' < BWT < '2500' then MAT_LBW = 1;
  else if '2500' <= BWT < '9999' then MAT_LBW = 0;

RUN;

PROC SORT DATA = link_table1;
BY SAM_PTB RACEHISP;
RUN;
PROC MEANS DATA = link_table1 N MEAN;
BY SAM_PTB RACEHISP;
VAR SAMBWT;
RUN;

PROC SORT DATA = link_table1;
BY MAT_PTB RACEHISP;
RUN;
PROC MEANS DATA = link_table1;
BY MAT_PTB RACEHISP;
VAR MATBWT;
RUN;

PROC FREQ DATA = link_table1;
TABLES SAM_PTB*RACEHISP;
RUN;

PROC FREQ DATA = link_table1;
TABLES MAT_PTB*RACEHISP;
RUN;
