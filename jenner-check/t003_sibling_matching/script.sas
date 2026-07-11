/************************************************************
PURPOSE: 1. Lots of checks on data
		 2. do descriptive analysis only
Adapted from "Chap1_g1_all tables.sas" for the Jenner compatibility
bundle: the original LIBNAME VA/AK pointed at the author's private
dissertation matching data; here VA.finalrecode_link is a small inline
mock cohort (last name, temp id, birth order) with the same shape. The
sibling-flagging technique below -- PROC SORT by last name and temp id,
then a first.-variable BY-group pass that increments a counter each time
a new temp id appears under the same last name -- is the author's own
logic for finding multi-birth sibling records, unchanged.
***************************************************************/

libname VA (work);

data VA.finalrecode_link;
  length alname1 $20 afname1 $20 bfname1 $20 blname1 $20;
  input alname1 $ atemp_id afname1 $ blname1 $ bfname1 $ CNUM SAM_BIRTHORDER SAM_WT M_DOB $ Plurality CHILD_FNAME $ CHILD_LNAME $;
  datalines;
Smith 101 Jane Smith Robert 1 2 3200 010180 1 Ann Smith
Smith 102 Jane Smith Robert 1 2 3100 010180 1 Beth Smith
Jones 103 Mary Jones Peter 2 1 2900 030181 1 Carl Jones
Diaz 104 Elena Diaz Luis 3 2 3300 050182 1 Dora Diaz
Diaz 105 Elena Diaz Luis 3 2 3050 050182 1 Eli Diaz
Diaz 105 Elena Diaz Luis 3 3 2950 050182 1 Faye Diaz
Nguyen 106 Linh Nguyen Minh 4 1 3400 070183 1 Grace Nguyen
Patel 107 Asha Patel Raj 5 2 3150 090180 1 Hari Patel
Patel 108 Asha Patel Raj 5 2 3000 090180 1 Ida Patel
Brown 109 Susan Brown James 6 1 3250 111181 1 Jack Brown
;
run;

PROC SORT DATA = VA.finalrecode_link;
BY alname1 atemp_id;
RUN;

/*flag potential siblings - if they have the same last name but different id_1*/

DATA PLU_2;
 SET VA.finalrecode_link;
 IF SAM_BIRTHORDER GT 1 THEN OUTPUT;
RUN;

PROC SORT DATA = PLU_2;
BY alname1 atemp_id;
RUN;

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

PROC FREQ DATA = MyLastData; TABLES alname1 afname1 blname1 bfname1 ; BY CNUM; RUN;

proc print data = MyLastData;
var alname1 bfname1 SAM_WT cnum CHILD_FNAME CHILD_LNAME M_DOB Plurality SAM_BIRTHORDER;
RUN;
