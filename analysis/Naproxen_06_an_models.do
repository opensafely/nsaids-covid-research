/*==============================================================================
DO FILE NAME:			Naproxen_06_an_models
PROJECT:				NSAID in COVID-19 
AUTHOR:					A Wong (modified from ICS study by A Schultze)
DATE: 					5 Jul 2020 					
DESCRIPTION OF FILE:	program  
						univariable regression
						multivariable regression 
						 model checks are in: 
							Naproxen_08_an_model_checks
DATASETS USED:			data in memory ($tempdir/analysis_dataset_STSET_outcome)

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
						table9, printed to analysis/$outdir
							
==============================================================================*/

* Open a log file

cap log close
log using $logdir\Naproxen_06_an_models, replace t

* Open Stata dataset
use $tempdir\analysis_dataset_STSET_$outcome, clear

/* Sense check outcomes=======================================================*/ 
drop exposure
rename naproxen_dose exposure
safetab exposure $outcome, missing row

/* Main Model=================================================================*/

/* Univariable model */ 

stcox i.exposure 
estimates save ./$tempdir/dose_univar, replace 

/* Multivariable models */ 

* Age and Gender 
* Age fit as spline in first instance, categorical below 

stcox i.exposure i.male age1 age2 age3 
estimates save ./$tempdir/dose_multivar1, replace 

* Age, Gender and Comorbidities 
stcox i.exposure i.male age1 age2 age3 	$varlist , strata(stp)				
										
estimates save ./$tempdir/dose_multivar2, replace 

/* Print table================================================================*/ 
*  Print the results for the main model 

cap file close tablecontent
file open tablecontent using ./$outdir/table9.txt, write text replace

* Column headings 
file write tablecontent ("Table 9: Association between current NSAID use according to dose and $tableoutcome - $population Population") _n
file write tablecontent _tab ("Number of events") _tab ("Total person-weeks") _tab ("Rate per 1,000") _tab ("Univariable") _tab _tab ("Age/Sex Adjusted") _tab _tab ///
						("Age/Sex and Comorbidity Adjusted") _tab _tab _n
file write tablecontent _tab _tab _tab _tab ("HR") _tab ("95% CI") _tab ("HR") _tab ///
						("95% CI") _tab ("HR") _tab ("95% CI") _n
file write tablecontent ("Main Analysis") _n 					

* Row headings 
local lab0: label dose 0
local lab1: label dose 1
local lab2: label dose 2
local lab3: label dose 3
 
/* Counts */
 
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
	
* Second row, exposure = 1 (naproxen low dose)

file write tablecontent ("`lab1'") _tab  

	safecount if exposure == 1 & $outcome == 1
	local event = r(N)
	su total_follow_up if exposure == 1
	local person_week = r(mean)/7
	local rate = 1000*(`event'/`person_week')
	file write tablecontent (`event') _tab %10.0f (`person_week') _tab %3.2f (`rate') _tab
	
/* Main Model */ 
estimates use ./$tempdir/dose_univar 
lincom 1.exposure, eform
file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _tab 

estimates use ./$tempdir/dose_multivar1 
lincom 1.exposure, eform
file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _tab 

estimates use ./$tempdir/dose_multivar2  
lincom 1.exposure, eform
file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _n 

* Third row, exposure = 2 (naproxen high dose)

file write tablecontent ("`lab2'") _tab  

	safecount if exposure == 2 & $outcome == 1
	local event = r(N)
	su total_follow_up if exposure == 2
	local person_week = r(mean)/7
	local rate = 1000*(`event'/`person_week')
	file write tablecontent (`event') _tab %10.0f (`person_week') _tab %3.2f (`rate') _tab
	
/* Main Model */ 
estimates use ./$tempdir/dose_univar 
lincom 2.exposure, eform
file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _tab 

estimates use ./$tempdir/dose_multivar1 
lincom 2.exposure, eform
file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _tab 

estimates use ./$tempdir/dose_multivar2  
lincom 2.exposure, eform
file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _n 
	
* Fourth row, exposure = 3 (Other NSAIDs)

file write tablecontent ("`lab3'") _tab  

	safecount if exposure == 3 & $outcome == 1
	local event = r(N)
	su total_follow_up if exposure == 3
	local person_week = r(mean)/7
	local rate = 1000*(`event'/`person_week')
	file write tablecontent (`event') _tab %10.0f (`person_week') _tab %3.2f (`rate') _tab

/* Main Model */ 
estimates use ./$tempdir/dose_univar 
lincom 3.exposure, eform
file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _tab 

estimates use ./$tempdir/dose_multivar1 
lincom 3.exposure, eform
file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _tab 

estimates use ./$tempdir/dose_multivar2  
lincom 3.exposure, eform
file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _n 

file write tablecontent _n
file close tablecontent


* Close log file 
log close
