/*==============================================================================
DO FILE NAME:			11_an_models_GPcount_A&E
PROJECT:				NSAID in COVID-19 
DATE: 					5 Jul 2020 
AUTHOR:					A Wong (modified from NSAID study by A Schultze)								
DESCRIPTION OF FILE:	program 10, restrict to known ethnicity (complete case analysis) 
DATASETS USED:			data in memory ($tempdir/analysis_dataset_STSET_outcome)

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
						table7, printed to analysis/$outdir
							
==============================================================================*/

* Open a log file

cap log close
log using $logdir\11_an_models_GPcount_A&E, replace t

* Open Stata dataset
use $tempdir\analysis_dataset_STSET_$outcome, clear

/* Sense check outcomes=======================================================*/ 

safetab exposure $outcome, missing row

/* Main Model=================================================================*/

* Age, Gender and Comorbidities 
stcox i.exposure i.male age1 age2 age3  $varlist                 ///
										i.gp_consult             ///
										i.aande_attendance_last_year, strata(stp)		
										
estimates save ./$tempdir/multivar_gp_ae, replace 

/* Print table================================================================*/ 
*  Print the results for the main model 

cap file close tablecontent
file open tablecontent using ./$outdir/table7.txt, write text replace

* Column headings 
file write tablecontent ("Table 7: Association between current NSAID use and death - $population Population, additionally adjusted for GP count and A&E count") _n
file write tablecontent _tab ("Number of events") _tab ("Total person-weeks") _tab ("Rate per 1,000") _tab ("Univariable") _tab _tab ("Age/Sex Adjusted") _tab _tab ///
						("Age/Sex and Comorbidity Adjusted") _tab _tab _n
file write tablecontent _tab _tab _tab _tab ("HR") _tab ("95% CI") _tab ("HR") _tab ///
						("95% CI") _tab ("HR") _tab ("95% CI") _n
file write tablecontent ("Sensitivity Analysis") _n 					

* Row headings 
local lab0: label exposure 0
local lab1: label exposure 1
 
* First row, exposure = 0 (reference)

	safecount if exposure == 0 & $outcome == 1
	local event = r(N)
    bysort exposure: egen total_follow_up = total(_t)
	su total_follow_up if exposure == 0
	local person_week = r(mean)/7
	local rate = 1000*(`event'/`person_week')
	
	file write tablecontent ("`lab0'") _tab
	file write tablecontent (`event') _tab %10.0f (`person_week') _tab %3.2f (`rate') _tab
	file write tablecontent ("1.00 (ref)") _tab _tab ("1.00 (ref)") _tab _tab ("1.00 (ref)") _n
	
* Second row, exposure = 1 (NSAID)

file write tablecontent ("`lab1'") _tab  

	safecount if exposure == 1 & $outcome == 1
	local event = r(N)
	su total_follow_up if exposure == 1
	local person_week = r(mean)/7
	local rate = 1000*(`event'/`person_week')
	file write tablecontent (`event') _tab %10.0f (`person_week') _tab %3.2f (`rate') _tab

/* Main Model */ 
estimates use ./$tempdir/multivar_gp_ae
lincom 1.exposure, eform
file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _n 


file write tablecontent _n
file close tablecontent

* Close log file 
log close

