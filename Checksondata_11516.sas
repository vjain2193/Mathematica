/************************************************************
PURPOSE: 1. Lots of checks on data
		 2. do descriptive analysis only
***************************************************************/

LIBNAME VA 'C:\Users\njain\Documents\Personal\Dissertation\Data_NJ\Matching data\Matching_762015';
LIBNAME AK 'C:\Users\njain\Documents\Personal\Dissertation\Data_NJ\Final_data\Final_deidentified data';
proc contents data = VA.finalrecode_link;run;

DATA AK.Final_noID;
	SET VA.finalrecode_link;
	DROP AMNAME1 ATTEND_LNAME BMNAME1 Child_FName Child_LName Child_MName Child_SName GEO_ADD GEO_CODES GEO_COUNTY GEO_CTY GEO_CTY_FIPS
	GEO_CTY_NAME GEO_MATCH GEO_MUNIC GEO_RESULT GEO_STATE GEO_ZIP GEO_ZIPCODE GEO_ZIP_4 M_FNAME M_MIDDLE M_MNAME M_RES_OUT M_R_COUNTY
	M_R_MUNI M_R_STATE M_STATE M_ZIPCODE M_mail_add SAM_CHLIDNAME SAM_MAIDENMOM SAM_MUNOFBIR SAM_MUNOFRES SAM_M_LNAME SAM_STATERES 
	afname1 alname1 aminit bfname1 blname1 bminit M_ADD_1 M_ADD_2 M_CTY mage fage;
RUN;

/*ARACE BGENDER CDOB CHILD_DOB CHILD_VAR CHILD_YOB CLIN_EST_GEST Date_LMP F_DOB F_EDU F_HISP MAT_DATE_GA LMP MAT_combgest MDOB MNTH_PREN_CARE MOM_VAR BWT
M_DOB M_EDU M_HISP M_RACE SAM_AGEMOM SAM_BWTLB SAM_BWTOZ SAM_CHILD_DOB SAM_DATE_GA SAM_DATE_LASTMEN SAM_EDUMOM SAM_ETHNMOM SAM_MARITAL SAM_M_RACE SAM_RACEMOM
SAM_WT SAM_WTLBOZ SAM_combgest Year_LMP S_Mm S_Dd mage mage_cat mother_age*/


PROC FREQ DATA = CHECK;
*TABLES S_Mm*S_Dd;  /*Month and day from G1 LMP*/
*TABLES M_Mm*M_Dd;	/*Month and day from G2 LMP*/
*TABLES CLIN_EST_GEST SAM_DATE_GA  SAM_Var MAT_DATE_GA MAT_Var;
*TABLES ARACE M_RACE SAM_M_RACE M_HISP SAM_ETHNMOM ;
*TABLES SAM_AGEMOM mage_cat mother_age;
*TABLES BWT SAM_WT SAM_WTLBOZ SAM_BWTLB SAM_BWTOZ;
*Tables Plurality ;
RUN;

PROC FREQ DATA = AK.Final_noID;
TABLES  SAM_BIRTHORDER;
RUN;

/************program to find sibship records only in generation 1***********/

DATA PLU_2;
 SET VA.finalrecode_link;
 IF SAM_BIRTHORDER GT 1 THEN OUTPUT;
RUN;
PROC FREQ DATA = AK.Final_noID;
TABLES  SAM_BIRTHORDER;
RUN;

PROC SORT DATA = PLU_2;
BY alname1 atemp_id;
RUN;

/*flag potential siblings - if they have the same last name but different id_1*/

Data FlagSiblings (drop=atemp_id sibFlag);
    set PLU_2 (keep = alname1 atemp_id);

    by alname1 atemp_id;
    if first.alname1 then sibFlag = 0;
    if first.atemp_id then sibFlag + 1;
    if sibFlag > 1 then output;
run;

/*you now have identified a list of last names where the id_1 value is not the same for each last name*/
proc sort data = flagSiblings nodupkey; by alname1; run;

/* merge the last names back to the original data set and flag*/
data MyLastData;
    merge PLU_2 (in=ds1)
          flagSiblings(in=ds2);
    by alname1;
    if ds1 and ds2 then sibFlag = 1;
    * if you only want to keep the siblings you can uncomment out the line below;
    if sibFlag = 1;
run;
PROC SORT DATA = MyLastData;
BY CNUM;
RUN;
PROC FREQ; TABLES alname1 afname1 blname1 bfname1 ; BY CNUM;RUN;

proc print data = MyLastData;
var alname1 bfname1 SAM_WT cnum CHILD_FNAME CHILD_LNAME M_DOB Plurality SAM_BIRTHORDER;
RUN; 

/************program to find sibship records only in generation 2***********/









