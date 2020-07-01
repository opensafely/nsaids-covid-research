/*==============================================================================
DO FILE NAME:			04b_an_descriptive_table_arthritis
PROJECT:				NSAID in COVID-19  
AUTHOR:					A Wong (modified from ICS study by A Schultze)
DATE: 					22 June 2020
DESCRIPTION OF FILE:	Produce a table of baseline characteristics, by exposure
						Generalised to produce same columns as levels of exposure
						Output to a textfile for further formatting
DATASETS USED:			$Tempdir\analysis_dataset.dta
DATASETS CREATED: 		None
OTHER OUTPUT: 			Results in txt: $outdir\table1.txt 
						Log file: $logdir\04b_an_descriptive_table_nsaid
							
==============================================================================*/

* Open a log file
capture log close
log using $logdir\04b_an_descriptive_table_arthritis, replace t

* Open Stata dataset
use $tempdir\analysis_dataset, clear

/*==============================================================================*/

/* PROGRAMS TO AUTOMATE TABULATIONS===========================================*/ 

********************************************************************************
* All below code from K Baskharan 
* Generic code to output one row of table

cap prog drop generaterow
program define generaterow
syntax, variable(varname) condition(string) 
	
	cou
	local overalldenom=r(N)
	
	qui sum `variable' if `variable' `condition'
	file write tablecontent (r(max)) _tab
	
	cou if `variable' `condition'
	local rowdenom = r(N)
	local colpct = 100*(r(N)/`overalldenom')
	file write tablecontent %9.0gc (`rowdenom')  (" (") %3.1f (`colpct') (")") _tab

	cou if exposure == 0 
	local rowdenom = r(N)
	cou if exposure == 0 & `variable' `condition'
	local pct = 100*(r(N)/`rowdenom') 
	file write tablecontent %9.0gc (r(N)) (" (") %3.1f (`pct') (")") _tab

	cou if exposure == 1 
	local rowdenom = r(N)
	cou if exposure == 1 & `variable' `condition'
	local pct = 100*(r(N)/`rowdenom')
	file write tablecontent %9.0gc (r(N)) (" (") %3.1f  (`pct') (")") _n
	
end

/* Explanatory Notes 

defines a program (SAS macro/R function equivalent), generate row
the syntax row specifies two inputs for the program: 

	a VARNAME which is your variable 
	a CONDITION which is a string of some condition you impose 
	
the program counts if variable and condition and returns the counts
column percentages are then automatically generated
this is then written to the text file 'tablecontent' 
the number followed by space, brackets, formatted pct, end bracket and then tab

the format %3.1f specifies length of 3, followed by 1 dp. 

*/ 

********************************************************************************
* Generic code to output one section (varible) within table (calls above)

cap prog drop tabulatevariable
prog define tabulatevariable
syntax, variable(varname) min(real) max(real) [missing]

	local lab: variable label `variable'
	file write tablecontent ("`lab'") _n 

	forvalues varlevel = `min'/`max'{ 
		generaterow, variable(`variable') condition("==`varlevel'")
	}
	
	if "`missing'"!="" generaterow, variable(`variable') condition(">=.")

end

********************************************************************************

/* Explanatory Notes 

defines program tabulate variable 
syntax is : 

	- a VARNAME which you stick in variable 
	- a numeric minimum 
	- a numeric maximum 
	- optional missing option, default value is . 

forvalues lowest to highest of the variable, manually set for each var
run the generate row program for the level of the variable 
if there is a missing specified, then run the generate row for missing vals

*/ 

********************************************************************************
* Generic code to summarise a continuous variable 

cap prog drop summarizevariable 
prog define summarizevariable
syntax, variable(varname) 

	local lab: variable label `variable'
	file write tablecontent ("`lab'") _n 
	
	qui summarize `variable', d
	file write tablecontent ("Median (IQR)") _tab 
	file write tablecontent (r(p50)) (" (") (r(p25)) ("-") (r(p75)) (")") _tab
							
	qui summarize `variable' if exposure == 0, d
	file write tablecontent (r(p50)) (" (") (r(p25)) ("-") (r(p75)) (")") _tab

	qui summarize `variable' if exposure == 1, d
	file write tablecontent (r(p50)) (" (") (r(p25)) ("-") (r(p75)) (")") _n
	
	qui summarize `variable', d
	file write tablecontent ("Min, Max") _tab 
	file write tablecontent (r(min)) (", ") (r(max)) ("") _tab
							
	qui summarize `variable' if exposure == 0, d
	file write tablecontent (r(min)) (", ") (r(max)) ("") _tab

	qui summarize `variable' if exposure == 1, d
	file write tablecontent (r(min)) (", ") (r(max)) ("") _n
	
end

/* QUESTION FOR STATA REVIEWER - I WROTE THIS CONTINOUS VAR SUMMARY PROGRAM
but I don't quite understand why I seem to need ("") on the last row for the 
maxium value to display properly? Otherwise it seems to just be missing. 

Please check this extra carefully as well

*/ 

/* INVOKE PROGRAMS FOR TABLE 1================================================*/ 

*Set up output file
cap file close tablecontent
file open tablecontent using ./$outdir/table1.txt, write text replace

file open tablecontent using "D:/covid_dummy/output/table1.txt", write text replace

file write tablecontent ("Table 1: Demographic and Clinical Characteristics - $population") _n

* Exposure labelled columns

local lab0: label exposure 0
local lab1: label exposure 1

file write tablecontent _tab ("Total")				  			  _tab ///
							 ("`lab0'")			 			      _tab ///
							 ("`lab1'")  						  _n

* DEMOGRAPHICS (more than one level, potentially missing) 

gen byte cons=1
tabulatevariable, variable(cons) min(1) max(1) 
file write tablecontent _n 

tabulatevariable, variable(agegroup) min(1) max(6) 
file write tablecontent _n 

tabulatevariable, variable(male) min(0) max(1) 
file write tablecontent _n 

tabulatevariable, variable(bmicat) min(1) max(6) missing
file write tablecontent _n 

tabulatevariable, variable(smoke) min(1) max(3) missing 
file write tablecontent _n 

tabulatevariable, variable(smoke_nomiss) min(1) max(3) missing 
file write tablecontent _n 

tabulatevariable, variable(ethnicity) min(1) max(5) missing 
file write tablecontent _n 

tabulatevariable, variable(imd) min(1) max(5) missing
file write tablecontent _n 

tabulatevariable, variable(diabcat) min(1) max(4) missing
file write tablecontent _n 

tabulatevariable, variable(arthritis_type) min(0) max(3) missing
file write tablecontent _n 

file write tablecontent _n _n

** COMORBIDITIES (categorical and continous)

** COMORBIDITIES (binary)

foreach comorb of varlist 	hypertension			 		///
							heart_failure					///
							other_heart_disease		 		///
							diabetes 						///
							copd							///
							other_respiratory       	    ///
							cancer       					///
							immunodef_any		 			///
							ckd								///
                            osteoarthritis                  ///							
							rheumatoid                      ///
							flu_vaccine 					///
							pneumococcal_vaccine			///
							statin 							///
							ppi  							///
							steroid_prednisolone            ///
							hydroxychloroquine              ///
							dmards_primary_care             ///
							gp_consult                      ///
							annde_attendance_last_year   {

local lab: variable label `comorb'
file write tablecontent ("`lab'") _n 
							
generaterow, variable(`comorb') condition("==1")
file write tablecontent _n

}

* COMORBIDITIES (continuous)

summarizevariable, variable(gp_consult_count)
summarizevariable, variable(age)
*summarizevariable, variable(aande_attendance_count)
summarizevariable, variable(follow_up_ons)
*summarizevariable, variable(follow_up_ecds)

file close tablecontent

* Close log file 
log close

