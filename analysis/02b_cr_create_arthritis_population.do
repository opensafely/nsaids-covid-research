/*==============================================================================
DO FILE NAME:			02b_cr_create_arthritis_population
PROJECT:				NSAIDs in COVID-19 
DATE: 					19 June 2020 
AUTHOR:					A Wong (modified from ICS study by A Schultze)							
DESCRIPTION OF FILE:	program 01, OA/RA population (cohort 2) for NSAID project  
						check inclusion/exclusion citeria
						drop patients if not relevant 
DEPENDENCIES: 
DATASETS USED:			data in memory (from analysis/input_ra_oa_population.csv)

DATASETS CREATED: 		analysis_dataset.dta
						lives in folder analysis/$tempdir 
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
							
==============================================================================*/

* Open a log file

cap log close
log using $logdir\02b_cr_create_arthritis_population, replace t

/* APPLY INCLUSION/EXCLUIONS==================================================*/ 

noi di "KEEP THOSE WITH OA/RA DIAGNOSIS"
keep if osteoarthritis==1 | rheumatoid==1

noi di "DROP MISSING GENDER:"
drop if inlist(sex,"I", "U")

noi di "DROP AGE <18:"
*DONE BY PYTHON

noi di "DROP AGE >110:"
*DONE BY PYTHON

noi di "DROP AGE MISSING:"
*DONE BY PYTHON

noi di "DROP IMD MISSING"
*DONE BY PYTHON

noi di "DROP IF DEAD BEFORE INDEX"
datacheck stime_onscoviddeath > date("$indexdate", "DMY"), nolist
drop if stime_onscoviddeath <= date("$indexdate", "DMY")

noi di "DROP PATIENTS WITH MI, STROKE, GASTROINTESTINAL BLEEDING"
*DONE BY PYTHON

noi di "DROP PATIENTS WITH ASPIRIN PRESCRIBING"
*DONE BY PYTHON

noi di "DROP PATIENTS WITH CURRENT ASTHMA"
*DONE BY PYTHON


/* CHECK INCLUSION AND EXCLUSION CRITERIA=====================================*/ 

* DATA STRUCTURE: Confirm one row per patient 
duplicates tag patient_id, generate(dup_check)
assert dup_check == 0 
drop dup_check

* INCLUSION 1: Patients with rheumatoid arthritis/osteoarthritis (everyone should have a date for this variable)
datacheck !(osteoarthritis==0 & rheumatoid==0) , nol

* INCLUSION 2: >=18 and <=110 at 1 March 2020 
assert age < .
datacheck age >= 18, nolist
datacheck age <= 110, nolist
 
* INCLUSION 3: M or F gender at 1 March 2020 
assert inlist(sex, "M", "F")

* EXCLUSION 1: 12 months or baseline time 
* [VARIABLE NOT EXPORTED, CANNOT QUANTIFY]

* EXCLUSION 2: MISSING IMD
assert inlist(imd, 1, 2, 3, 4, 5)

* EXCLUSION 3-5: PATIENTS WITH MI, STROKE, GI BLEED
*if successfully done by python - all value of this variable should be missing
foreach var of varlist 	mi ///
                        stroke ///
						gi_bleed_ulcer ///
                      { 
		capture confirm string variable `var'
		if _rc!=0 {
			noi di "`var': numeric variable datacheck"
			noi datacheck `var'==. , nolist
		}
		else {
		    noi di "`var': string variable datacheck"
			noi datacheck missing(`var'), nolist
		}
					  }

* EXCLUSION 6: PATIENTS WHO WERE PRESCRIBED ASPIRIN WITHIN 10 YEARS BEFORE COHORT ENTRY
datacheck aspirin_ever_date < d(15feb2010) if aspirin_ever_date!=. , nolist

* EXCLUSION 7: PATIENTS WITH CURRENT ASTHMA
//just a rough check - because no exact date is given for asthma dx and tx
datacheck asthma_date < d(15feb2017) if ///
asthma_date!=. & saba_single!=. & saba_single > d(15dec2019), nolist

datacheck saba_single < d(15nov2019) if ///
asthma_date!=. & saba_single!=. & asthma_date > d(15feb2017) , nolist


/* SAVE DATA==================================================================*/	

save $tempdir\analysis_dataset, replace

* Save a version set on outcomes
stset stime_$outcome, fail($outcome) id(patient_id) enter(enter_date) origin(enter_date)	
save $tempdir\analysis_dataset_STSET_$outcome, replace

* Close log file 
log close