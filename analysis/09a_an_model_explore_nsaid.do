/*==============================================================================
DO FILE NAME:			09a_model_exploration_nsaid
PROJECT:				NSAID in COVID-19 
AUTHOR:					A Wong (modified from NSAID study by A Schultze)
DATE: 					5 Jul 2020 						
DESCRIPTION OF FILE:	program 09 
						explore different models 
DATASETS USED:			data in memory ($tempdir/analysis_dataset_STSET_outcome)

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
						table5, printed to analysis/$outdir
							
==============================================================================*/

* Open a log file

cap log close
log using $logdir\09a_model_exploration_nsaid, replace t

* Open Stata dataset
use $tempdir\analysis_dataset_STSET_$outcome, clear

/* Print table================================================================*/ 
*  Print the results for the main model 

cap file close tablecontent
file open tablecontent using ./$outdir/table5.txt, write text replace

* Column headings 
file write tablecontent ("Table 5: 1 by 1 comorbidity adjustments (after age/sex and strata adjustments) - $population population") _n
file write tablecontent _tab ("HR") _tab ("95% CI") _n

/* Adjust one covariate at a time=============================================*/

foreach var of varlist 	obese4cat			     	///
						i.smoke_nomiss				///
						i.imd 						///
						i.ckd	 					///		
						i.hypertension			 	///		
						i.heart_failure				///		
						i.other_heart_disease		///		
						i.diabcat 					///	
						i.copd                      ///
						i.other_respiratory         ///
						i.immunodef_any		 		///
						i.cancer     				///	
						i.rheumatoid 				///	
						i.osteoarthritis			///	
						i.statin 					///	
						i.ppi                       ///
						i.steroid_prednisolone      ///
						i.hydroxychloroquine        ///
						i.dmards_primary_care       ///
						i.flu_vaccine 				///	
						i.pneumococcal_vaccine		///	
						i.gp_consult                ///
						i.aande_attendance_last_year { 
	
	local lab: variable label `var'
	file write tablecontent ("`lab'") _n 
	
	qui stcox i.exposure i.male age1 age2 age3 i.`var', strata(stp)	
		
		local lab0: label exposure 0
		local lab1: label exposure 1

		file write tablecontent ("`lab0'") _tab
		file write tablecontent ("1.00 (ref)") _tab _n
		file write tablecontent ("`lab1'") _tab  
		
		qui lincom 1.exposure, eform
		file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _n _n
									
} 	

file write tablecontent _n
file close tablecontent

* Close log file 
log close


