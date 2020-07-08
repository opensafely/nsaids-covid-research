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
*summ  stime_onscoviddeath stime_ecds,  format
summ  died_date_ons died_date_onscovid, format
*summ  aande_attendance_with_covid, format

* Follow-up for outcomes
datacheck follow_up_ons > 0, nolist
*datacheck follow_up_ecds > 0, nolist 
summ  follow_up_ons, detail
*summ  follow_up_ecds, detail

* Outcome date day lags since cohort entry
* check how the death count tail out
gen days_died_since_entry = died_date_ons - enter_date
su days_died_since_entry, detail

* Diabetes (diacat) check if zero event in category DM without HbA1c measures (after first run)
datacheck onscoviddeath==0 if exposure==1 & diabcat==4, nolist
datacheck onscoviddeath==0 if exposure==0 & diabcat==4, nolist


/* LOGICAL RELATIONSHIPS======================================================*/ 

* BMI
bysort bmicat: summ bmi
safetab bmicat obese4cat, m

* Age
bysort agegroup: summ age
safetab agegroup age70, m

* Smoking
safetab smoke smoke_nomiss, m

* Diabetes
safetab diabcat diabetes, m

* CKD
safetab ckd egfr_cat, m

* Osteoarthritis/rheumatoid arthritis/both
safetab arthritis_type osteoarthritis, m
safetab arthritis_type rheumatoid, m

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

safetab agegroup bmicat, 	row 
safetab agegroup smoke, 	row  
safetab agegroup ethnicity, row 
safetab agegroup imd, 		row 

safetab bmicat smoke, 		 row   
safetab bmicat ethnicity, 	 row 
safetab bmicat imd, 	 	 row 
safetab bmicat hypertension, row 
                            
safetab smoke ethnicity, 	row 
safetab smoke imd, 			row 
safetab smoke hypertension, row 
                            
safetab ethnicity imd, 		row 

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
						aande_attendance_last_year  ///
						steroid_prednisolone        ///
                        hydroxychloroquine          ///
                        dmards_primary_care {
		
 	safetab agegroup `var', row 
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
						aande_attendance_last_year  ///
						steroid_prednisolone        ///
                        hydroxychloroquine          ///
						dmards_primary_care {
						
 	safetab male `var', row 
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
						aande_attendance_last_year  ///
						steroid_prednisolone        ///
                        hydroxychloroquine          ///
						dmards_primary_care {
	
 	safetab smoke `var', row 
}

/* RELATIONSHIP WITH NSAID EXPOSURE AND COVARIATES (past 4 months)=============*/

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
						diab_control                ///
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
						aande_attendance_last_year  ///
					    steroid_prednisolone        ///
                        hydroxychloroquine          ///
						dmards_primary_care  {
							
	safetab `var' exposure , col m
}

bysort exposure: su gp_consult_count, detail
bysort exposure: su aande_attendance_count , detail
bysort exposure: su age, detail
bysort exposure: su follow_up_ons, detail

/* RELATIONSHIP WITH Naproxen dose EXPOSURE AND COVARIATES=====================*/

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
						diab_control                ///
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
						aande_attendance_last_year  ///
					    steroid_prednisolone        ///
                        hydroxychloroquine          ///
						dmards_primary_care    {
							
	safetab `var' naproxen_dose , col m
}

bysort naproxen_dose: su gp_consult_count, detail
bysort naproxen_dose: su aande_attendance_count , detail
bysort naproxen_dose: su age, detail
bysort naproxen_dose: su follow_up_ons, detail

/* RELATIONSHIP WITH Ibuprofen EXPOSURE AND COVARIATES=====================*/

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
						diab_control                ///
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
						aande_attendance_last_year  ///
					    steroid_prednisolone        ///
                        hydroxychloroquine          ///
						dmards_primary_care  {
							
	safetab `var' ibuprofen , col m
}

bysort ibuprofen: su gp_consult_count, detail
bysort ibuprofen: su aande_attendance_count , detail
bysort ibuprofen: su age, detail
bysort ibuprofen: su follow_up_ons, detail

/* RELATIONSHIP WITH Cox-2 EXPOSURE AND COVARIATES=====================*/

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
						diab_control                ///
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
						aande_attendance_last_year  ///
					    steroid_prednisolone        ///
                        hydroxychloroquine          ///
						dmards_primary_care  {
							
	safetab `var' cox_nsaid , col m
}

bysort cox_nsaid: su gp_consult_count, detail
bysort cox_nsaid: su aande_attendance_count , detail
bysort cox_nsaid: su age, detail
bysort cox_nsaid: su follow_up_ons, detail

/* RELATIONSHIP WITH NSAID EXPOSURE AND COVARIATES (past 2 months)=============*/

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
						diab_control                ///
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
						aande_attendance_last_year  ///
					    steroid_prednisolone        ///
                        hydroxychloroquine          ///
						dmards_primary_care  {
							
	safetab `var' nsaid_two_months , col m
}

bysort nsaid_two_months: su gp_consult_count, detail
bysort nsaid_two_months: su aande_attendance_count , detail
bysort nsaid_two_months: su age, detail
bysort nsaid_two_months: su follow_up_ons, detail

/* SENSE CHECK OUTCOMES=======================================================*/

safetab onscoviddeath, m
*safetab ecdscovid, m

* Close log file 
log close



