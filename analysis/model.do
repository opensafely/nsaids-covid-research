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


/*  Pre-analysis data manipulation  */

do "00_cr_create_analysis_dataset.do"

* nsaid specific data manipulation   
do "01a_cr_create_nsaid_exposure_outcome.do"
do "02a_cr_create_nsaid_population.do"

/*  Checks  */

do "03_an_checks.do"

/* Run analysis */ 

* nsaid specific analyses 
do "04a_an_descriptive_table_nsaid.do"
do "05a_an_descriptive_plots_nsaid.do"
do "06a_an_models_nsaid.do"
*do "07a_an_models_interact_nsaid.do"
*do "08a_an_model_checks_nsaid.do"
*do "09a_an_model_explore_nsaid.do"
*do "10a_an_models_ethnicity_nsaid.do"

/***************************************************************************
***************************************************************************
 Cohort 2: Osteoarthritis/rheumatoid arthritis 
***************************************************************************
===================================================================*/

clear

import delimited `c(pwd)'/output/input_ra_oa_population.csv, clear

set more off 

* Create directories required 

capture mkdir arthritis_output
capture mkdir arthritis_log
capture mkdir arthritis_tempdata

global population "Rheumatoid_arthritis_&_osteoarthritis"
global outcome "onscoviddeath"
global outdir  "arthritis_output" 
global logdir  "arthritis_log"
global tempdir "arthritis_tempdata"


/*  Pre-analysis data manipulation  */

do "00_cr_create_analysis_dataset.do"

* OA/RA specific data manipulation   
do "01b_cr_create_arthritis_exposure_outcome.do"
do "02b_cr_create_arthritis_population.do"

/*  Checks  */

do "03_an_checks.do"

/* Run analysis */ 

* arthritis specific analyses 
do "04b_an_descriptive_table_arthritis.do"
do "05b_an_descriptive_plots_arthritis.do"
do "06b_an_models_arthritis.do"
*do "07b_an_models_interact_arthritis.do"
*do "08b_an_model_checks_arthritis.do"
*do "09b_an_model_explore_arthritis.do"
*do "10b_an_models_ethnicity_arthritis.do"

/* 	SENSITIVITY 1=============================================================

/* 	SENSITIVITY 2=============================================================*/


/* 	SENSITIVITY 3=============================================================*/


/* 	SENSITIVITY 4=============================================================*/





