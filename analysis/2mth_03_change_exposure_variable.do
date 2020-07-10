/*==============================================================================
DO FILE NAME:			2mth_03_change_exposure_variable
PROJECT:				NSAID in COVID-19 
DATE: 					8 Jul 2020 
AUTHOR:					A Wong 
								
DESCRIPTION OF FILE:	program 03, 
                        change exposure variable name to run sensitivity analysis 
DATASETS USED:			data in memory 

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
							
==============================================================================*/
* Open a log file

cap log close
log using $logdir\2mth_03_change_exposure_variable, replace t

/*==============================================================================*/

use "$tempdir\analysis_dataset", clear
drop exposure
rename nsaid_two_months exposure
save "$tempdir\analysis_dataset", replace

use "$tempdir\analysis_dataset_STSET_$outcome", clear
drop exposure
rename nsaid_two_months exposure
save "$tempdir\analysis_dataset_STSET_$outcome", replace

log close