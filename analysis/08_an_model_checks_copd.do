/*==============================================================================
DO FILE NAME:			08_an_model_checks_copd
PROJECT:				ICS in COVID-19 
DATE: 					20th of May 2020  
AUTHOR:					A Schultze 									
DESCRIPTION OF FILE:	program 08 
						check the PH assumption, produce graphs 
DATASETS USED:			data in memory ($tempdir/analysis_dataset_STSET_outcome)

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
						table4, printed to analysis/$outdir
						schoenplots1-x, printed to analysis?$outdir 
							
==============================================================================*/

* Open a log file

cap log close
log using $logdir\08_an_model_checks_copd, replace t

* Open Stata dataset
use $tempdir\analysis_dataset_STSET_$outcome, clear

/* Quietly run models, perform test and store results in local macro==========*/

qui stcox i.exposure 
estat phtest, detail
local univar_p = round(r(p),0.001)
di `univar_p'
 
estat phtest, plot(1.exposure) ///
			  graphregion(fcolor(white)) ///
			  ylabel(, nogrid labsize(small)) ///
			  xlabel(, labsize(small)) ///
			  xtitle("Time", size(small)) ///
			  ytitle("Scaled Shoenfeld Residuals", size(small)) ///
			  msize(small) ///
			  mcolor(gs6) ///
			  msymbol(circle_hollow) ///
			  scheme(s1mono) ///
			  title ("Schoenfeld residuals against time, univariable", position(11) size(medsmall)) 

graph export "$outdir/schoenplot1.svg", as(svg) replace

* Close window 
graph close  
			  
stcox i.exposure i.male age1 age2 age3 
estat phtest, detail
local multivar1_p = round(r(phtest)[2,4],0.001)
 
estat phtest, plot(1.exposure) ///
			  graphregion(fcolor(white)) ///
			  ylabel(, nogrid labsize(small)) ///
			  xlabel(, labsize(small)) ///
			  xtitle("Time", size(small)) ///
			  ytitle("Scaled Shoenfeld Residuals", size(small)) ///
			  msize(small) ///
			  mcolor(gs6) ///
			  msymbol(circle_hollow) ///
			  scheme(s1mono) ///
			  title ("Schoenfeld residuals against time, age and sex adjusted", position(11) size(medsmall)) 			  

graph export "$outdir/schoenplot2.svg", as(svg) replace

* Close window 
graph close
		  
stcox i.exposure i.male age1 age2 age3 $varlist, strata(stp)	
estat phtest, detail
local multivar2_p = round(r(phtest)[2,4],0.001)
 
estat phtest, plot(1.exposure) ///
			  graphregion(fcolor(white)) ///
			  ylabel(, nogrid labsize(small)) ///
			  xlabel(, labsize(small)) ///
			  xtitle("Time", size(small)) ///
			  ytitle("Scaled Shoenfeld Residuals", size(small)) ///
			  msize(small) ///
			  mcolor(gs6) ///
			  msymbol(circle_hollow) ///
			  scheme(s1mono) ///
			  title ("Schoenfeld residuals against time, fully adjusted", position(11) size(medsmall)) 		  
			  
graph export "$outdir/schoenplot3.svg", as(svg) replace

* Close window 
graph close

* Print table of results======================================================*/	


cap file close tablecontent
file open tablecontent using ./$outdir/table4.txt, write text replace

* Column headings 
file write tablecontent ("Table 4: Testing the PH assumption for $tableoutcome- $population Population") _n
file write tablecontent _tab ("Univariable") _tab ("Age/Sex Adjusted") _tab ///
						("Age/Sex and Comorbidity Adjusted") _tab _n
						
file write tablecontent _tab ("p-value") _tab ("p-value") _tab ("p-value") _tab _n

* Row heading and content  
file write tablecontent ("Treatment Exposure") _tab
file write tablecontent ("`univar_p'") _tab ("`multivar1_p'") _tab ("`multivar2_p'")

file write tablecontent _n
file close tablecontent

* Close log file 
log close
