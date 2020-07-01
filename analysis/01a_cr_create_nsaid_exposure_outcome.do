/*==============================================================================
DO FILE NAME:			01a_cr_create_nsaid_exposure_outcome
PROJECT:				NSAID in COVID-19 
DATE: 					17 June 2020 
AUTHOR:					A Wong (modified from ICS study by A Schultze)
																	
DESCRIPTION OF FILE:	create exposures and outcomes of interest 
DATASETS USED:			data in memory (from analysis/input.csv)

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
							
==============================================================================*/

* Open a log file
cap log close
log using $logdir\01a_cr_create_nsaid_exposure_outcome, replace t

/*==============================================================================*/

sort patient_id

* Date of cohort entry, 1 Mar 2020
gen enter_date = date("$indexdate", "DMY")
format enter_date %td

/* TREATMENT EXPOSURE=========================================================*/	

*Main analysis: NSAIDs exposure within 4 months before cohort entry
gen exposure = (nsaid_last_four_months_date	< .) 

label var exposure "NSAID Treatment Exposure"
label define exposure 0 "non-current NSAID use" 1 "current NSAID use"
label values exposure exposure 

* Subgroup analysis 1: low dose naproxen vs high dose naproxen vs other NSAIDs
* Currently classified as high dose naproxen if any of them in same month & year

gen naproxen_dose=1       if naproxen_low_date!=. & ///
naproxen_low_date == max(nsaid_last_four_months_date, naproxen_low_date, naproxen_high_date)

replace naproxen_dose=2   if naproxen_high_date!=. & ///
naproxen_high_date == max(nsaid_last_four_months_date, naproxen_low_date, naproxen_high_date)

replace naproxen_dose=3   if naproxen_dose==. & nsaid_last_four_months_date!=.

replace naproxen_dose=0   if naproxen_dose==.

label var naproxen_dose "naproxen dose vs other NSAIDs"
label define dose 0 "no current use of NSAIDs" 1 "low dose naproxen" 2 "high dose naproxen" 3 "other NSAIDs"
label values naproxen_dose dose 

* Subgroup analysis 2: ibuprofen vs other NSAIDs
* Currently classified as ibuprofen if any of them in same month & year

gen ibuprofen=1        if ibuprofen_date!=. & ///
ibuprofen_date == max(nsaid_last_four_months_date, ibuprofen_date)

replace ibuprofen=2    if ibuprofen==. & nsaid_last_four_months_date!=.

replace ibuprofen=0    if ibuprofen==.

label var ibuprofen "ibuprofen vs other NSAIDs"
label define nsaid_ibu 0 "no current use of NSAIDs" 1 "ibuprofen" 2 "other NSAIDs"
label values ibuprofen nsaid_ibu 

* Subgroup analysis 3: Cox-2 specific vs non-specific NSAIDs
* Currently classified as Cox-2 if any of them in same month & year

gen cox_nsaid=1       if cox_medication_date!=. & ///
cox_medication_date == max(nsaid_last_four_months_date, cox_medication_date)

replace cox_nsaid=2   if cox_nsaid==. & nsaid_last_four_months_date!=.

replace cox_nsaid=0   if cox_nsaid==.

label var cox_nsaid "Cox-2 specific vs other specific NSAIDs"
label define nsaid_type 0 "no current use of NSAIDs" 1 "Cox-2 specific NSAIDs" 2 "Other specific NSAIDs" 
label values cox_nsaid nsaid_type 

* Sensitivity analysis: NSAIDs exposure within 2 months before cohort entry
gen nsaid_two_months = (nsaid_last_two_months_date	< .) 

label var nsaid_two_months "NSAID Treatment Exposure in past two months"
label define exposure_2_months 0 "non-current NSAID use" 1 "current NSAID use"
label values nsaid_two_months exposure_2_months 


/* OUTCOME AND SURVIVAL TIME==================================================*/
* Date of data available
gen onscoviddeathcensor_date 	= date("$onscoviddeathcensor", 	"DMY")
gen ecdscensor_date             = date("$ecdscensor", "DMY")

* Format the dates
format 	enter_date					///
		onscoviddeathcensor_date 	///
		ecdscensor_date             %td

/*   Outcomes   */

* Dates of: ONS any death, ECDS due to covid
/* Recode to dates from the strings (outcomes and censoring date (subsequent nsaid exposure)
foreach var of varlist 	died_date_ons 		///
						aande_attendance    ///
						nsaid_after_march   ///
						{
						
	confirm string variable `var'
	rename `var' `var'_dstr
	gen `var' = date(`var'_dstr, "YMD")
	drop `var'_dstr
	format `var' %td 
	
}
Keep a&e outcome in comment for now*/
foreach var of varlist 	died_date_ons 		///
						nsaid_after_march   ///
						{
						
	confirm string variable `var'
	rename `var' `var'_dstr
	gen `var' = date(`var'_dstr, "YMD")
	drop `var'_dstr
	format `var' %td 
	
}
* Generate date of Covid death in ONS
gen died_date_onscovid = died_date_ons if died_ons_covid_flag_any == 1

* Format outcome dates
format died_date_ons died_date_onscovid %td
*format aande_attendance %td 

/*  Identify date of end of follow-up
(first: end data availability (ONS & ECDS), death, outcome, or NSAID expsure in non-exposed group) */

* For looping later, name must be stime_binary_outcome_name

* Primary outcome: ONS covid-19 death
gen stime_onscoviddeath = min(onscoviddeathcensor_date, died_date_ons) ///
 if exposure==1
replace stime_onscoviddeath = min(onscoviddeathcensor_date, died_date_ons, nsaid_after_march) ///
 if exposure==0

/* Secondary outcome: ECDS due to covid-19
gen stime_ecds = min(onscoviddeathcensor_date, ecdscensor_date, died_date_ons, aande_attendance) if exposure==1
replace stime_ecds = min(onscoviddeathcensor_date, ecdscensor_date, died_date_ons, aande_attendance, nsaid_after_march) if exposure==0
*/ 
* Generate variables for follow-up person-days for each outcome
gen follow_up_ons = stime_onscoviddeath - enter_date
*gen follow_up_ecds = stime_ecds - enter_date
 
* Format date variables
format stime* %td 

* Binary indicators for outcomes
* Primary outcome: ONS covid-19 death
gen onscoviddeath = 1 if died_date_onscovid!=. & ///
died_date_onscovid>=enter_date & died_date_onscovid<=stime_onscoviddeath

replace onscoviddeath = 0 if onscoviddeath == .
 
/* Secondary outcome: ECDS due to covid-19
gen ecdscovid = 1 if aande_attendance!=. & ///
aande_attendance>=enter_date & aande_attendance<=stime_ecds

replace ecdscovid = 0 if ecdscovid == .
*/
/* LABEL VARIABLES============================================================*/

* Outcomes and follow-up
label var enter_date					"Date of study entry"
label var ecdscensor_date 		     	"Date of admin censoring for ECDS data"
label var onscoviddeathcensor_date 		"Date of admin censoring for ONS deaths"

label var ecdscovid    			       "Failure/censoring indicator for outcome: ecds covid"
label var onscoviddeath					"Failure/censoring indicator for outcome: ONS covid death"
label var died_date_onscovid 			"Date of ONS Death (Covid-19 only)"

label var died_date_ons                 "ONS death date (any cause)"
label var nsaid_after_march           "Earliest date of exposure to NSAIDs after cohort entry"
label var aande_attendance              "AE attendance due to Covid-19"

* End of follow-up (date)
label var stime_onscoviddeath 			"End of follow-up: ONS covid death"
*label var stime_ecds 	     			"End of follow-up: ecds covid"

* Duration of follow-up
label var follow_up_ons                 "Number of days (follow-up) for ONS covid death"
*label var follow_up_ecds                "Number of days (follow-up) for ecds covid"
/* ==========================================================================*/

log close