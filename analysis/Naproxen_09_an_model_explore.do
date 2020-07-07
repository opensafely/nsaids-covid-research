/*==============================================================================
DO FILE NAME:			Naproxen_09_an_model_explore
PROJECT:				NSAID in COVID-19 
AUTHOR:					A Wong (modified from NSAID study by A Schultze)
DATE: 					5 Jul 2020 						
DESCRIPTION OF FILE:	program 
						explore different models 
DATASETS USED:			data in memory ($tempdir/analysis_dataset_STSET_outcome)

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
						table11, printed to analysis/$outdir
							
==============================================================================*/

* Open a log file

cap log close
log using $logdir\Naproxen_09_an_model_explore, replace t

* Open Stata dataset
use $tempdir\analysis_dataset_STSET_$outcome, clear

drop exposure
rename naproxen_dose exposure

/* Print table================================================================*/ 
*  Print the results for the main model 

cap file close tablecontent
file open tablecontent using ./$outdir/table11.txt, write text replace

* Column headings 
file write tablecontent ("Table 11: 1 by 1 comorbidity adjustments (after age/sex and strata adjustments) - $population population") _n
file write tablecontent _tab ("HR") _tab ("95% CI") _n

/* Adjust one covariate at a time=============================================*/

foreach var in $varlist                    ///
			   i.diabcat                   ///
			   i.gp_consult                ///
			   i.aande_attendance_last_year { 
			       
	local var: subinstr local var "i." ""
	local lab: variable label `var'
	file write tablecontent ("`lab'") _n 
	
	qui stcox i.exposure i.male age1 age2 age3 i.`var', strata(stp)	
		
		local lab0: label dose 0
		local lab1: label dose 1
		local lab2: label dose 2
		local lab3: label dose 3

		file write tablecontent ("`lab0'") _tab
		file write tablecontent ("1.00 (ref)") _tab _n
		file write tablecontent ("`lab1'") _tab  
		
		qui lincom 1.exposure, eform
		file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _n 
		file write tablecontent ("`lab2'") _tab  
		
		qui lincom 2.exposure, eform
		file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _n 
		file write tablecontent ("`lab3'") _tab  
		
		qui lincom 3.exposure, eform
		file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _n  _n
									
} 	

file write tablecontent _n
file close tablecontent

* Close log file 
log close


