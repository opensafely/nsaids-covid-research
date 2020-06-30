/*==============================================================================
DO FILE NAME:			03_an_checks
PROJECT:				NSAID in COVID-19 
AUTHOR:					A Wong (modified from ICS study by A Schultze)
DATE: 					15 June 2020 
DESCRIPTION OF FILE:	Run sanity checks on all variables
							- Check variables take expected ranges 
							- Cross-check logical relationships 
							- Explore expected relationships 
							- Check relationship between exposure and all covariates (same as table 1)
							
DATASETS USED:			$tempdir\analysis_dataset.dta
DATASETS CREATED: 		None
OTHER OUTPUT: 			Log file: $logdir\03_an_checks
							
==============================================================================*/

* Open a log file

capture log close
log using $logdir\03_an_checks, replace t

* Open Stata dataset
use $tempdir\analysis_dataset, clear

*run ssc install if not already installed on your computer
*ssc install datacheck 

*Duplicate patient check
datacheck _n==1, by(patient_id) nol

/* EXPECTED VALUES============================================================*/ 

* Age
datacheck age<., nol
datacheck inlist(agegroup, 1, 2, 3, 4, 5, 6), nol
datacheck inlist(age70, 0, 1), nol

* Sex
datacheck inlist(male, 0, 1), nol

* BMI 
datacheck inlist(obese4cat, 1, 2, 3, 4), nol
datacheck inlist(bmicat, 1, 2, 3, 4, 5, 6, .u), nol

* IMD
datacheck inlist(imd, 1, 2, 3, 4, 5), nol

* Ethnicity
datacheck inlist(ethnicity, 1, 2, 3, 4, 5, .u), nol

* Smoking
datacheck inlist(smoke, 1, 2, 3, .u), nol
datacheck inlist(smoke_nomiss, 1, 2, 3), nol 

* Type of arthritis
datacheck inlist(arthritis_type, 0, 1, 2, 3), nol

* Check date ranges for all treatment variables  
*need to add IBUPROFEN too!!!

foreach i in nsaid_last_four_months     ///
             nsaid_last_two_months     ///
             naproxen_low               ///
			 naproxen_high              ///
			 cox_medication             ///
			 ibuprofen                  ///
			 indometacin {
	
	summ `i'_date, format

}

* Check date ranges for all comorbidities 
foreach var of varlist  ckd     					///			
						hypertension				///
						other_respiratory 			///
						other_heart_disease 		///
						heart_failure				///
						copd 						///
						diabetes					///
						cancer 	        			///
						rheumatoid 					///
						osteoarthritis				///
						ppi         				///	
						statin                      ///
						steroid_prednisolone        ///
                        hydroxychloroquine          ///
                        dmards_primary_care { 
						
	summ `var'_date, format

}

* Death outcome flag (covid)
//Underlying Covid-death should be a subset of Any Covid-death
datacheck !(died_ons_covid_flag_underlying==1 & died_ons_covid_flag_any!=1), nolist

* Outcome dates
summ  stime_onscoviddeath stime_ecds,  format
summ  died_date_ons died_date_onscovid aande_attendance, format

* Follow-up for outcomes
datacheck follow_up_ons > 0, nolist
datacheck follow_up_ecds > 0, nolist 
summ  follow_up_ons, details
summ  follow_up_ecds, details

* Outcome date day lags since cohort entry
* check how the death count tail out
gen days_died_since_entry = died_date_ons - enter_date
su days_died_since_entry, detail

/* LOGICAL RELATIONSHIPS======================================================*/ 

* BMI
bysort bmicat: summ bmi
tab bmicat obese4cat, m

* Age
bysort agegroup: summ age
tab agegroup age70, m

* Smoking
tab smoke smoke_nomiss, m

* Diabetes
tab diabcat diabetes, m

* CKD
tab ckd egfr_cat, m

* Osteoarthritis/rheumatoid arthritis/both
tab arthritis_type osteoarthritis, m
tab arthritis_type rheumatoid, m

/* Treatment variables */ 

foreach var of varlist 	naproxen_dose		///
						cox_nsaid           ///
						ibuprofen    {
						
	tab exposure `var', row m

}

datacheck naproxen_dose>0   if exposure==1, nol
datacheck cox_nsaid>0       if exposure==1, nol

/* EXPECTED RELATIONSHIPS=====================================================*/ 

/*  Relationships between demographic/lifestyle variables  */

tab agegroup bmicat, 	row 
tab agegroup smoke, 	row  
tab agegroup ethnicity, row 
tab agegroup imd, 		row 

tab bmicat smoke, 		 row   
tab bmicat ethnicity, 	 row 
tab bmicat imd, 	 	 row 
tab bmicat hypertension, row 
                            
tab smoke ethnicity, 	row 
tab smoke imd, 			row 
tab smoke hypertension, row 
                            
tab ethnicity imd, 		row 

* Relationships with age
foreach var of varlist  ckd     					///	
						hypertension				///
						other_respiratory 			///
						other_heart_disease 		///
						heart_failure				///
						copd 						///
						diabetes					///
						cancer      				///
						statin 						///
						ppi   						///
						flu_vaccine					///
						pneumococcal_vaccine		///								
						immunodef_any				///
						rheumatoid                  ///
						osteoarthritis              ///
						gp_consult 		            ///
						steroid_prednisolone        ///
                        hydroxychloroquine          ///
                        dmards_primary_care {
		
 	tab agegroup `var', row 
 }


 * Relationships with sex
foreach var of varlist  ckd     					///	
						hypertension				///
						other_respiratory 			///
						other_heart_disease 		///
						heart_failure				///
						copd 						///
						diabetes					///
						cancer      				///
						statin 						///
						ppi   						///
						flu_vaccine					///
						pneumococcal_vaccine		///								
						immunodef_any				///
						rheumatoid                  ///
						osteoarthritis              ///
						gp_consult 					///
						steroid_prednisolone        ///
                        hydroxychloroquine          ///
						dmards_primary_care {
						
 	tab male `var', row 
}

 * Relationships with smoking
foreach var of varlist  ckd     					///	
						hypertension				///
						other_respiratory 			///
						other_heart_disease 		///
						heart_failure				///
						copd 						///
						diabetes					///
						cancer      				///
						statin 						///
						ppi   						///
						flu_vaccine					///
						pneumococcal_vaccine		///								
						immunodef_any				///
						rheumatoid                  ///
						osteoarthritis              ///
						gp_consult   				///
						steroid_prednisolone        ///
                        hydroxychloroquine          ///
						dmards_primary_care {
	
 	tab smoke `var', row 
}

/* RELATIONSHIP WITH EXPOSURE AND COVARIATES===================================*/

foreach var of varlist  agegroup                    ///
                        sex                         ///
						bmicat                      ///
						ethnicity                   ///
						imd                         ///
						smoke_nomiss                ///
						hypertension				///
						heart_failure				///
						other_heart_disease 		///	
						diabcat   					///
						copd 						///						
						other_respiratory 			///
						cancer      				///
						immunodef_any				///
						ckd     					///	
						osteoarthritis              ///
						rheumatoid                  ///
						arthritis_type              ///
						flu_vaccine					///
						pneumococcal_vaccine		///							
						statin 						///
						ppi   						///
						gp_consult   				///
					    steroid_prednisolone        ///
                        hydroxychloroquine          ///
						dmards_primary_care {
							
	tab `var' exposure , col m
}

bysort exposure: su gp_consult_count, detail
bysort exposure: su aande_attendance_count , detail
bysort exposure: su age, detail

/* SENSE CHECK OUTCOMES=======================================================*/

tab onscoviddeath, m
tab ecdscovid, m

* Close log file 
log close



