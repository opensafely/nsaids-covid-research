pwd
import delimited `c(pwd)'/output/input_nsaid_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"
/***************************************************************************
***************************************************************************
 Cohort 1: Recent use of Nsaids users in past 3 years
***************************************************************************
 ======================================================================*/

* Create directories required 

capture mkdir nsaid_output
capture mkdir nsaid_log
capture mkdir nsaid_tempdata

* Set globals that will print in programs and direct output

global population "nsaid"
global outcome    "onscoviddeath"
global outdir  	  "nsaid_output" 
global logdir     "nsaid_log"
global tempdir    "nsaid_tempdata"
global varlist    i.obese4cat			    ///
				  i.smoke_nomiss		    ///
				  i.imd 					///
				  i.ckd	 					///		
				  i.hypertension			///		
				  i.heart_failure			///		
				  i.other_heart_disease		///		
				  i.diab_control			///	
				  i.copd                    ///
				  i.other_respiratory       ///
				  i.immunodef_any		 	///
				  i.cancer     				///	
				  i.rheumatoid 				///	
				  i.osteoarthritis			///	
				  i.statin 					///	
				  i.ppi                     ///
				  i.steroid_prednisolone    ///
				  i.hydroxychloroquine      ///
				  i.dmards_primary_care     ///
				  i.flu_vaccine 			///	
				  i.pneumococcal_vaccine

/*  Pre-analysis data manipulation  */

do "00_cr_create_analysis_dataset.do"

* nsaid specific data manipulation   
do "01_cr_create_exposure_outcome.do"
do "02a_cr_create_nsaid_population.do"

/*  Checks  */

do "03_an_checks.do"

/* Run analysis */ 

* nsaid specific analyses 
do "04_an_descriptive_table.do"
do "05_an_descriptive_plots.do"
do "06a_an_models_nsaid.do"
do "07_an_models_interact.do"
do "08_an_model_checks.do"
do "09_an_model_explore.do"
do "10_an_models_ethnicity.do"

/***************************************************************************
***************************************************************************
 Cohort 2: Osteoarthritis/rheumatoid arthritis 
***************************************************************************
===================================================================*/

clear

cd ..

import delimited `c(pwd)'/output/input_ra_oa_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required 

capture mkdir arthritis_output
capture mkdir arthritis_log
capture mkdir arthritis_tempdata

global population "Rheumatoid_arthritis_&_osteoarthritis"
global outcome "onscoviddeath"
global outdir  "arthritis_output" 
global logdir  "arthritis_log"
global tempdir "arthritis_tempdata"
global varlist    i.obese4cat			    ///
				  i.smoke_nomiss		    ///
				  i.imd 					///
				  i.ckd	 					///		
				  i.hypertension			///		
				  i.heart_failure			///		
				  i.other_heart_disease		///		
				  i.diab_control			///	
				  i.copd                    ///
				  i.other_respiratory       ///
				  i.immunodef_any		 	///
				  i.cancer     				///	
				  i.arthritis_type			///	
				  i.statin 					///	
				  i.ppi                     ///
				  i.steroid_prednisolone    ///
				  i.hydroxychloroquine      ///
				  i.dmards_primary_care     ///
				  i.flu_vaccine 			///	
				  i.pneumococcal_vaccine

/*  Pre-analysis data manipulation  */

do "00_cr_create_analysis_dataset.do"

* OA/RA specific data manipulation   
do "01_cr_create_exposure_outcome.do"
do "02b_cr_create_arthritis_population.do"

/*  Checks  */

do "03_an_checks.do"

/* Run analysis */ 

* arthritis specific analyses 
do "04_an_descriptive_table.do"
do "05_an_descriptive_plots.do"
do "06b_an_models_arthritis.do"
do "07_an_models_interact.do"
do "08_an_model_checks.do"
do "09_an_model_explore.do"
do "10_an_models_ethnicity.do"

/* 	SENSITIVITY 1=============================================================

/* 	SENSITIVITY 2=============================================================*/


/* 	SENSITIVITY 3=============================================================*/


/* 	SENSITIVITY 4=============================================================*/





