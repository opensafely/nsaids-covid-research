/*==============================================================================
DO FILE NAME:			07_an_models_interact
PROJECT:				NSAID in COVID-19 
AUTHOR:					A Wong (modified from NSAID study by A Schultze)
DATE: 					5 Jul 2020 										
DESCRIPTION OF FILE:	program 07, evaluate age interaction 
DATASETS USED:			data in memory ($tempdir/analysis_dataset_STSET_outcome)

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
						table3, printed to analysis/$outdir
							
==============================================================================*/

* Open a log file

cap log close
log using $logdir\07_an_models_interact, replace t

* Open Stata dataset
use $tempdir\analysis_dataset_STSET_$outcome, clear

/* Age Interaction============================================================*/ 

/* Check Counts */ 

bysort age70: tab exposure $outcome, row

/* Univariable model */ 

stcox i.exposure i.age70
estimates store A

stcox i.exposure##i.age70
estimates store B
estimates save ./$tempdir/univar_int, replace 

lrtest A B
local univar_p = round(r(p),0.001)

/* Multivariable models */ 

* Age and Gender 

stcox i.exposure i.age70 i.male
estimates store A

stcox i.exposure##i.age70 i.male
estimates store B
estimates save ./$tempdir/multivar1_int, replace 

lrtest A B
local multivar1_p = round(r(p),0.001)

* Age, Gender and Comorbidities 
stcox i.exposure i.age70 i.male $varlist, strata(stp)		
										
estimates store A

stcox i.exposure##i.age70 i.male $varlist, strata(stp)		
estimates store B
estimates save ./$tempdir/multivar2_int, replace 

lrtest A B
local multivar2_p = round(r(p),0.001)

/* Print interaction table====================================================*/ 
cap file close tablecontent
file open tablecontent using ./$outdir/table3.txt, write text replace

* Column headings 
file write tablecontent ("Table 3: Current NSAID use and $outcome, Age Interaction - $population Population") _n
file write tablecontent  _tab ("Number of events") _tab ("Total person-weeks") _tab ("Rate per 1,000") _tab ("Univariable") _tab _tab _tab ("Age/Sex Adjusted") _tab _tab _tab  ///
						("Age/Sex and Comorbidity Adjusted") _tab _tab _tab _n
file write tablecontent _tab _tab _tab _tab ("HR") _tab ("95% CI") _tab ("p (interaction)") _tab ("HR") _tab ///
						("95% CI") _tab ("p (interaction)") _tab ("HR") _tab ("95% CI") _tab ("p (interaction)") _tab _n

* Overall p-values 
file write tablecontent ("Agegroup") _tab _tab _tab _tab _tab _tab ("`univar_p'") ///
						_tab _tab _tab ("`multivar1_p'") /// 
						_tab _tab _tab ("`multivar2_p'") _n

						
* Generic program to print model for a level of another variable 
cap prog drop printinteraction
prog define printinteraction 
syntax, variable(varname) min(real) max(real) 

	forvalues varlevel = `min'/`max'{ 

		* Row headings 
		file write tablecontent ("`varlevel'") _n 	

		local lab0: label exposure 0
		local lab1: label exposure 1
		 
		/* Counts */
			
		* First row, exposure = 0 (reference)
		
    	file write tablecontent ("`lab0'") _tab

			safecount if exposure == 0  & `variable' == `varlevel' & $outcome == 1
            local event = r(N)
		    bysort exposure `variable': egen total_follow_up = total(_t)
            su total_follow_up if exposure == 0 & `variable' == `varlevel'
            local person_week = r(mean)/7
            local rate = 1000*(`event'/`person_week')

			
		file write tablecontent (`event') _tab %10.0f (`person_week') _tab %3.2f (`rate') _tab
        file write tablecontent ("1.00 (ref)") _tab _tab ("1.00 (ref)") _tab _tab ("1.00 (ref)") _n

			
		* Second row, exposure = 1 (NSAID)

		file write tablecontent ("`lab1'") _tab  


			safecount if exposure == 1 & `variable' == `varlevel' & $outcome == 1
	        local event = r(N)
            su total_follow_up if exposure == 1 & `variable' == `varlevel'
            local person_week = r(mean)/7
            local rate = 1000*(`event'/`person_week')
            file write tablecontent (`event') _tab %10.0f (`person_week') _tab %3.2f (`rate') _tab

		* Print models 
		estimates use ./$tempdir/univar_int 
		qui lincom 1.exposure + 1.exposure#`varlevel'.`variable', eform
		file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _tab _tab

		estimates use ./$tempdir/multivar1_int
		qui lincom 1.exposure + 1.exposure#`varlevel'.`variable', eform
		file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _tab _tab

		estimates use ./$tempdir/multivar2_int
		qui lincom 1.exposure + 1.exposure#`varlevel'.`variable', eform
		file write tablecontent %4.2f (r(estimate)) _tab %4.2f (r(lb)) (" - ") %4.2f (r(ub)) _tab _n 

		drop total_follow_up
	} 
		
end

printinteraction, variable(age70) min(0) max(1) 

file write tablecontent _n
file close tablecontent

* Close log file 
log close








