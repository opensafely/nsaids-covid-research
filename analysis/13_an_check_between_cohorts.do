/*==============================================================================
DO FILE NAME:			13_an_check_between_cohorts
PROJECT:				NSAID in COVID-19 
AUTHOR:					A Wong
DATE: 					10 November 2020 					
DESCRIPTION OF FILE:	program 13
						To check how many patients overlapped between cohorts of
						NSAIDs prescribed 3 years prior to cohort entry and
						rheumatoid arthritis/osteoarthritis

DATASETS USED:			data in memory ($tempdir/analysis_dataset)

DATASETS CREATED: 		none

OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
==============================================================================*/
* Open a log file
capture log close

log using $logdir\13_an_check_between_cohorts, replace t

/*============================================================================*/
* Open Stata dataset
* Cohort 1:
use $tempdir\analysis_dataset, clear
keep patient_id exposure
rename exposure exposure_cohort1

global tempdir "arthritis_tempdata"

* Cohort 2:
merge 1:1 patient_id using $tempdir\analysis_dataset , keepusing(patient_id exposure)

noi di "Number of people who were involved in both cohorts 1 and 2"
safecount if _merge == 3

noi di "Number of exposed people who were involved in both cohorts 1 and 2"
safecount if exposure_cohort1 == 1 & _merge == 3
safecount if exposure == 1 & _merge == 3
safecount if exposure_cohort1 == 1 & exposure == 1 & _merge == 3 

noi di "Number of non-exposed people who were involved in both cohorts 1 and 2"
safecount if exposure_cohort1 == 0 & _merge == 3
safecount if exposure == 0 & _merge == 3
safecount if exposure_cohort1 == 0 & exposure == 0 & _merge == 3 

log close


