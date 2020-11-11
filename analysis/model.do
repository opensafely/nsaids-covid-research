/*pwd
import delimited `c(pwd)'/output/input_nsaid_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

adopath + "./extra_ados"
/***************************************************************************
***************************************************************************
 Cohort 1: Recent use of Nsaids users in past 3 years
***************************************************************************
 ======================================================================*/

* Create directories required 

capture mkdir nsaid_output
capture mkdir nsaid_log
capture mkdir nsaid_tempdata

capture mkdir nsaid_output_DAG
capture mkdir nsaid_log_DAG

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

global km_ymax 0.001
global df 3
global cum_death_ymax 0.1

/*  Pre-analysis data manipulation  */

do "00a_cr_create_analysis_dataset.do"

* nsaid specific data manipulation   
do "01_cr_create_exposure_outcome.do"
do "02a_cr_create_nsaid_population.do"

/*  Checks  */

do "03_an_checks.do"

/* Run analysis */ 

* Any NSAIDs specific analyses 
do "04_an_descriptive_table.do"
do "05_an_descriptive_plots.do"
do "06a_an_models_nsaid.do"
do "07_an_models_interact.do"
do "08_an_model_checks.do"
do "09_an_model_explore.do"

/* 	SENSITIVITY ANALYSIS 1: =============================================
Restrict people with known ethnicity ======================================================================*/
do "10_an_models_ethnicity.do"

/* 	SENSITIVITY ANALYSIS 2: =============================================
GP count and A&E attandence as additional covariates ======================================================================*/
do "11_an_models_GPcount_A&E.do"

* Plot survival curves
do "12_an_models_adj_survival_curve.do"

* Naproxen dose specific analyses
do "Naproxen_04_an_descriptive_table.do"

do "Naproxen_05_an_descriptive_plots.do"
do "Naproxen_06_an_models.do"
do "Naproxen_08_an_model_checks.do"
do "Naproxen_09_an_model_explore.do"

* Cox-2 NSAIDs specific analyses
do "Cox2_04_an_descriptive_table.do"

do "Cox2_05_an_descriptive_plots.do"
do "Cox2_06_an_models.do"
do "Cox2_08_an_model_checks.do"
do "Cox2_09_an_model_explore.do"

* Ibuprofen specific analyses
do "Ibuprofen_04_an_descriptive_table.do"
do "Ibuprofen_05_an_descriptive_plots.do"
do "Ibuprofen_06_an_models.do"
do "Ibuprofen_08_an_model_checks.do"
do "Ibuprofen_09_an_model_explore.do"

/* 	post-hoc analysis 1: =============================================
use DAG model for covariate adjustment
======================================================================*/
global outdir  	  "nsaid_output_DAG" 
global logdir     "nsaid_log_DAG"
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
				  i.steroid_prednisolone    ///
				  i.hydroxychloroquine      ///
				  i.aande_attendance_last_year ///
				  i.dmards_primary_care     

do "posthoc_01_an_models_DAG.do"


/* 	Flowchart =============================================*/
global logdir     "nsaid_log"

cd ..
import delimited `c(pwd)'/output/input_nsaid_population_flow_chart.csv, clear

cd  "`c(pwd)'/analysis"

do "flow_chart_a_nsaids.do"

/* 	SENSITIVITY ANALYSIS 3: =============================================
Varying exposure definition to within 2 months prior to cohort entry ======================================================================*/

clear 

cd ..
import delimited `c(pwd)'/output/input_nsaid_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required 

capture mkdir nsaid_output_sens3
capture mkdir nsaid_log_sens3
capture mkdir nsaid_tempdata_sens3

* Set globals that will print in programs and direct output

global population "nsaid"
global outcome    "onscoviddeath"
global outdir  	  "nsaid_output_sens3" 
global logdir     "nsaid_log_sens3"
global tempdir    "nsaid_tempdata_sens3"
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
do "00a_cr_create_analysis_dataset.do"
do "01_cr_create_exposure_outcome.do"
do "02a_cr_create_nsaid_population.do"
do "2mth_03_change_exposure_variable.do"

/*  Run analysis  */
do "06a_an_models_nsaid.do"
do "08_an_model_checks.do"

/* 	SENSITIVITY ANALYSIS 4: =============================================
Remove people who had indometacin 
 ======================================================================*/
clear

cd ..
import delimited `c(pwd)'/output/input_nsaid_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required 

capture mkdir nsaid_output_sens4
capture mkdir nsaid_log_sens4
capture mkdir nsaid_tempdata_sens4

* Set globals that will print in programs and direct output

global population "nsaid"
global outcome    "onscoviddeath"
global outdir  	  "nsaid_output_sens4" 
global logdir     "nsaid_log_sens4"
global tempdir    "nsaid_tempdata_sens4"
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
do "00a_cr_create_analysis_dataset.do"
do "01_cr_create_exposure_outcome.do"
do "S4_02a_cr_create_nsaid_population.do"

/*  Run analysis */
do "06a_an_models_nsaid.do"
do "08_an_model_checks.do"

/* 	SENSITIVITY ANALYSIS 5: =============================================
Exclude people who ever had aspirin 
======================================================================*/
clear
cd ..
import delimited `c(pwd)'/output/input_nsaid_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required

capture mkdir nsaid_output_sens5
capture mkdir nsaid_log_sens5
capture mkdir nsaid_tempdata_sens5

* Set globals that will print in programs and direct output

global population "nsaid"
global outcome    "onscoviddeath"
global outdir  	  "nsaid_output_sens5" 
global logdir     "nsaid_log_sens5"
global tempdir    "nsaid_tempdata_sens5"
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
do "00a_cr_create_analysis_dataset.do"
do "01_cr_create_exposure_outcome.do"
do "S5_02a_cr_create_nsaid_population.do"

/*  Run analysis */
do "06a_an_models_nsaid.do"
do "08_an_model_checks.do"


/* 	SENSITIVITY ANALYSIS 6: =============================================
Not censoring subsequent NSAIDs exposure in non-current exposed group
======================================================================*/
clear
cd ..
import delimited `c(pwd)'/output/input_nsaid_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required

capture mkdir nsaid_output_sens6
capture mkdir nsaid_log_sens6
capture mkdir nsaid_tempdata_sens6

* Set globals that will print in programs and direct output

global population "nsaid"
global outcome    "onscoviddeath"
global outdir  	  "nsaid_output_sens6" 
global logdir     "nsaid_log_sens6"
global tempdir    "nsaid_tempdata_sens6"
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
do "00a_cr_create_analysis_dataset.do"
do "S6_01_cr_create_exposure_outcome.do"
do "02a_cr_create_nsaid_population.do"

/* Run analysis */
do "06a_an_models_nsaid.do"
do "08_an_model_checks.do"


/* 	SENSITIVITY ANALYSIS 7: =============================================
Varying exposure definition to within 1 month prior to cohort entry ======================================================================*/

clear 

cd ..
import delimited `c(pwd)'/output/input_nsaid_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required 

capture mkdir nsaid_output_sens7
capture mkdir nsaid_log_sens7
capture mkdir nsaid_tempdata_sens7

* Set globals that will print in programs and direct output

global population "nsaid"
global outcome    "onscoviddeath"
global outdir  	  "nsaid_output_sens7" 
global logdir     "nsaid_log_sens7"
global tempdir    "nsaid_tempdata_sens7"
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
do "00a_cr_create_analysis_dataset.do"
do "01_cr_create_exposure_outcome.do"
do "02a_cr_create_nsaid_population.do"
do "1mth_03_change_exposure_variable.do"

/*  Run analysis  */
do "06a_an_models_nsaid.do"
do "08_an_model_checks.do"

/* 	SENSITIVITY ANALYSIS 8: =============================================
Limit to non-users to those who had stopped NSAIDs within 12 months
======================================================================*/

clear 

cd ..
import delimited `c(pwd)'/output/input_nsaid_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required 

capture mkdir nsaid_output_sens8
capture mkdir nsaid_log_sens8
capture mkdir nsaid_tempdata_sens8

* Set globals that will print in programs and direct output

global population "nsaid"
global outcome    "onscoviddeath"
global outdir  	  "nsaid_output_sens8" 
global logdir     "nsaid_log_sens8"
global tempdir    "nsaid_tempdata_sens8"
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
do "00a_cr_create_analysis_dataset.do"
do "S8-01_cr_create_exposure_outcome.do"
do "02a_cr_create_nsaid_population.do"

/*  Run analysis  */
do "06a_an_models_nsaid.do"
do "08_an_model_checks.do"


/* 	SENSITIVITY ANALYSIS 9: =============================================
Limit to non-users to those who had stopped NSAIDs within 2 years
======================================================================*/

clear 

cd ..
import delimited `c(pwd)'/output/input_nsaid_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required 

capture mkdir nsaid_output_sens9
capture mkdir nsaid_log_sens9
capture mkdir nsaid_tempdata_sens9

* Set globals that will print in programs and direct output

global population "nsaid"
global outcome    "onscoviddeath"
global outdir  	  "nsaid_output_sens9" 
global logdir     "nsaid_log_sens9"
global tempdir    "nsaid_tempdata_sens9"
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
do "00a_cr_create_analysis_dataset.do"
do "S9-01_cr_create_exposure_outcome.do"
do "02a_cr_create_nsaid_population.do"

/*  Run analysis  */
do "06a_an_models_nsaid.do"
do "08_an_model_checks.do"


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

capture mkdir arthritis_output_DAG
capture mkdir arthritis_log_DAG

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

global km_ymax 0.002
global df 2
global cum_death_ymax 0.2

/*  Pre-analysis data manipulation  */

do "00b_cr_create_analysis_dataset.do"

* OA/RA specific data manipulation   
do "01_cr_create_exposure_outcome.do"
do "02b_cr_create_arthritis_population.do"

/*  Checks  */

do "03_an_checks.do"

/* Run analysis */ 

* Any NSAIDs specific analyses 
do "04_an_descriptive_table.do"
do "05_an_descriptive_plots.do"
do "06b_an_models_arthritis.do"
do "07_an_models_interact.do"
do "08_an_model_checks.do"
do "09_an_model_explore.do"

/* 	SENSITIVITY ANALYSIS 1: =============================================
Restrict people with known ethnicity ======================================================================*/
do "10_an_models_ethnicity.do"

/* 	SENSITIVITY ANALYSIS 2: =============================================
GP count and A&E attandence as additional covariates ======================================================================*/
do "11_an_models_GPcount_A&E.do"

* Plot survival curves
do "12_an_models_adj_survival_curve.do"

* Naproxen dose specific analyses
do "Naproxen_04_an_descriptive_table.do"

do "Naproxen_05_an_descriptive_plots.do"
do "Naproxen_06_an_models.do"
do "Naproxen_08_an_model_checks.do"
do "Naproxen_09_an_model_explore.do"

* Cox-2 NSAIDs specific analyses
do "Cox2_04_an_descriptive_table.do"
do "Cox2_05_an_descriptive_plots.do"
do "Cox2_06_an_models.do"
do "Cox2_08_an_model_checks.do"
do "Cox2_09_an_model_explore.do"

* Ibuprofen specific analyses
do "Ibuprofen_04_an_descriptive_table.do"
do "Ibuprofen_05_an_descriptive_plots.do"
do "Ibuprofen_06_an_models.do"
do "Ibuprofen_08_an_model_checks.do"
do "Ibuprofen_09_an_model_explore.do"

/* 	post-hoc analysis 1: =============================================
use DAG model for covariate adjustment
======================================================================*/
global outdir  	  "arthritis_output_DAG" 
global logdir     "arthritis_log_DAG"
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
				  i.steroid_prednisolone    ///
				  i.hydroxychloroquine      ///
				  i.aande_attendance_last_year ///
				  i.dmards_primary_care     

do "posthoc_01_an_models_DAG.do"

/* 	Flowchart =============================================*/
global logdir     "arthritis_log"

cd ..
import delimited `c(pwd)'/output/input_ra_oa_population_flow_chart.csv, clear

cd  "`c(pwd)'/analysis"

do "flow_chart_b_arthritis.do"

/* 	SENSITIVITY ANALYSIS 3: =============================================
Varying exposure definition to within 2 months prior to cohort entry ======================================================================*/

clear

cd ..

import delimited `c(pwd)'/output/input_ra_oa_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required 

capture mkdir arthritis_output_sens3
capture mkdir arthritis_log_sens3
capture mkdir arthritis_tempdata_sens3

global population "Rheumatoid_arthritis_&_osteoarthritis"
global outcome "onscoviddeath"
global outdir  "arthritis_output_sens3" 
global logdir  "arthritis_log_sens3"
global tempdir "arthritis_tempdata_sens3"
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
do "00b_cr_create_analysis_dataset.do"
do "01_cr_create_exposure_outcome.do"
do "02b_cr_create_arthritis_population.do"
do "2mth_03_change_exposure_variable.do"

/*  Run analysis  */
do "06b_an_models_arthritis.do"
do "08_an_model_checks.do"


/* 	SENSITIVITY ANALYSIS 4: =============================================
Remove people who had indometacin 
 ======================================================================*/
clear

cd ..

import delimited `c(pwd)'/output/input_ra_oa_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required 

capture mkdir arthritis_output_sens4
capture mkdir arthritis_log_sens4
capture mkdir arthritis_tempdata_sens4

global population "Rheumatoid_arthritis_&_osteoarthritis"
global outcome "onscoviddeath"
global outdir  "arthritis_output_sens4" 
global logdir  "arthritis_log_sens4"
global tempdir "arthritis_tempdata_sens4"
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
do "00b_cr_create_analysis_dataset.do"
do "01_cr_create_exposure_outcome.do"
do "S4_02b_cr_create_arthritis_population.do"

/*  Run analysis  */
do "06b_an_models_arthritis.do"
do "08_an_model_checks.do"


/* 	SENSITIVITY ANALYSIS 5: =============================================
Exclude people who ever had aspirin 
======================================================================*/
clear

cd ..

import delimited `c(pwd)'/output/input_ra_oa_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required 

capture mkdir arthritis_output_sens5
capture mkdir arthritis_log_sens5
capture mkdir arthritis_tempdata_sens5

global population "Rheumatoid_arthritis_&_osteoarthritis"
global outcome "onscoviddeath"
global outdir  "arthritis_output_sens5" 
global logdir  "arthritis_log_sens5"
global tempdir "arthritis_tempdata_sens5"
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
do "00b_cr_create_analysis_dataset.do"
do "01_cr_create_exposure_outcome.do"
do "S5_02b_cr_create_arthritis_population.do"

/*  Run analysis  */
do "06b_an_models_arthritis.do"
do "08_an_model_checks.do"

/* 	SENSITIVITY ANALYSIS 6: =============================================
Not censoring subsequent NSAIDs exposure in non-current exposed group
======================================================================*/
clear

cd ..

import delimited `c(pwd)'/output/input_ra_oa_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required 

capture mkdir arthritis_output_sens6
capture mkdir arthritis_log_sens6
capture mkdir arthritis_tempdata_sens6

global population "Rheumatoid_arthritis_&_osteoarthritis"
global outcome "onscoviddeath"
global outdir  "arthritis_output_sens6" 
global logdir  "arthritis_log_sens6"
global tempdir "arthritis_tempdata_sens6"
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
do "00b_cr_create_analysis_dataset.do"
do "S6_01_cr_create_exposure_outcome.do"
do "02b_cr_create_arthritis_population.do"

/*  Run analysis */
do "06b_an_models_arthritis.do"
do "08_an_model_checks.do"

/* 	SENSITIVITY ANALYSIS 7: =============================================
Varying exposure definition to within 1 month prior to cohort entry ======================================================================*/

clear

cd ..

import delimited `c(pwd)'/output/input_ra_oa_population.csv, clear

set more off 

cd  "`c(pwd)'/analysis"

* Create directories required 

capture mkdir arthritis_output_sens7
capture mkdir arthritis_log_sens7
capture mkdir arthritis_tempdata_sens7

global population "Rheumatoid_arthritis_&_osteoarthritis"
global outcome "onscoviddeath"
global outdir  "arthritis_output_sens7" 
global logdir  "arthritis_log_sens7"
global tempdir "arthritis_tempdata_sens7"
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
do "00b_cr_create_analysis_dataset.do"
do "01_cr_create_exposure_outcome.do"
do "02b_cr_create_arthritis_population.do"
do "1mth_03_change_exposure_variable.do"

/*  Run analysis  */
do "06b_an_models_arthritis.do"
do "08_an_model_checks.do"
*/
/***********************************************************************
************************************************************************
Identify number of people overlapped in two different cohorts
************************************************************************/
global logdir     "nsaid_log"
global tempdir    "nsaid_tempdata"

do "13_an_check_between_cohorts.do"