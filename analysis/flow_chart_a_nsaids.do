/*==============================================================================
DO FILE NAME:			flow_chart_a_nsaids
PROJECT:				NSAID in COVID-19 
DATE: 					27 Jul 2020 
AUTHOR:					A Wong (modified from NSAID study by A Walker)								
DESCRIPTION OF FILE:	identify number of people included in each stage applying inclusion/exclusion criteria
DATASETS USED:			input_nsaid_population_flow_chart

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to analysis folder
						
							
==============================================================================*/

* Open a log file

cap log close
log using $logdir\flow_chart_a_nsaids, replace t

/*
# NSAID pop (RECEIVED NSAID IN PAST THREE YEARS PRIOR TO 1 MARCH 2020)
has_follow_up AND
nsaid_last_three_years AND
(age >=18 AND age <= 110) AND
imd >0 AND NOT (  
(has_asthma AND saba_single) OR
aspirin_ten_years OR
stroke OR
mi OR
gi_bleed_ulcer
*/
safecount
drop if has_follow_up!=1
safecount
drop if missing(nsaid_last_three_years)
safecount
drop if age < 18 | age > 110
safecount
keep if imd>0
safecount
drop if has_asthma==1 & !missing(saba_single)
safecount
drop if !missing(aspirin_ten_years)
safecount
drop if !missing(stroke)
safecount
drop if !missing(mi)
safecount
drop if !missing(gi_bleed_ulcer)
safecount

log close