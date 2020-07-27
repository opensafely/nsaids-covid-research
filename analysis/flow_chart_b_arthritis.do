/*==============================================================================
DO FILE NAME:			flow_chart_b_arthritis
PROJECT:				NSAID in COVID-19 
DATE: 					27 Jul 2020 
AUTHOR:					A Wong (modified from NSAID study by A Walker)								
DESCRIPTION OF FILE:	identify number of people included in each stage applying inclusion/exclusion criteria
DATASETS USED:			input_ra_oa_population_flow_chart

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to analysis folder
						
							
==============================================================================*/

* Open a log file

cap log close
log using $logdir\flow_chart_b_arthritis, replace t

/*
# osteoarthritis/ rheumatoid arthritis pop
has_follow_up AND
(rheumatoid OR osteoarthritis) AND
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
keep if !missing(rheumatoid) | !missing(osteoarthritis)
safecount
drop if age < 18 | age > 110
safecount
drop if imd==.
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