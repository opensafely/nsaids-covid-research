log using `c(pwd)'\flow_chart_numbers, replace t
import delimited input_nsaid_flow_chart.csv, clear

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
drop if nsaid_last_three_years!=1
safecount
drop if age_cat!=1
safecount
drop if imd==.
safecount
drop if has_asthma==1 & saba_single==1
safecount
drop if aspirin_ten_years==1
safecount
drop if stroke==1
safecount
drop if mi==1
safecount
drop if gi_bleed_ulcer==1
safecount


import delimited input_arthritis_flow_chart.csv, clear

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
keep if rheumatoid==1 | osteoarthritis==1
safecount
drop if age_cat!=1
safecount
drop if imd==.
safecount
drop if has_asthma==1 & saba_single==1
safecount
drop if aspirin_ten_years==1
safecount
drop if stroke==1
safecount
drop if mi==1
safecount
drop if gi_bleed_ulcer==1
safecount

log close