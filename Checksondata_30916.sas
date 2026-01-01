/*****************************************************
PURPOSE: TO CHECK AVERAGE BWT IN EACH PRETERM CATEGORY
******************************************************/

LIBNAME VA 'C:\Users\njain\Documents\Personal\Dissertation\Data_NJ\Matching data\Matching_762015';

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

/* recode race

	IF sam_race EQ 1 THEN RACEHISP = 0; /*WHITE
	ELSE IF sam_race EQ 2 THEN RACEHISP = 1; /*BLACK
	ELSE RACEHISP = 3; /*OTHER & MISSING
*/
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

PROC FREQ; 
TABLES SAM_PTB*RACEHISP;
RUN; 

PROC FREQ; 
TABLES MAT_PTB*RACEHISP;
RUN; 
