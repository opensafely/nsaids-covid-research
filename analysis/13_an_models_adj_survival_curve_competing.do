/*==============================================================================
DO FILE NAME:			13_an_models_adj_survival_curve_competing
PROJECT:				NSAID in COVID-19 
AUTHOR:					A Wong
DATE: 					10 Jul 2020 					
DESCRIPTION OF FILE:	program 13
						Using fully adjusted model; 
						taking into consideration of competing risk (non-covid death)
DATASETS USED:			data in memory ($tempdir/analysis_dataset_STSET_outcome)

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
						Adj_survival_curves_2.svg
						difference_survival_curves_2.svg
							
==============================================================================*/
* Open a log file
capture log close
log using $logdir\13_an_models_adj_survival_curve_competing, replace t

* Open Stata dataset
use $tempdir\analysis_dataset, clear

/*==============================================================================*/
* Create a variable denoting Covid-19 / Non-Covid-19 deaths
clonevar event = onscoviddeath

replace event = 2 if event == 0 & died_date_ons!=. & ///
died_date_ons>=enter_date & died_date_ons<=stime_onscoviddeath

label define event 0 "no event" 1 "covid-19 deaths" 2 "Non covid-19 deaths" 
label values event event 


* Run Covid-19 death model
preserve
stset stime_$outcome, failure(event=1) id(patient_id) enter(enter_date) origin(enter_date)	

* Fit the stpm2 model for Covid-19 death
xi i.exposure i.male $varlist
stpm2 _I* age1 age2 age3, scale(hazard) df(3) eform nolog

estimates store coviddeath
restore

* Run Non-Covid-19 death model
stset stime_$outcome, failure(event=2) id(patient_id) enter(enter_date) origin(enter_date)	

* Fit the stpm2 model for Non-Covid-19 death
xi i.exposure i.male $varlist
stpm2 _I* age1 age2 age3, scale(hazard) df(3) eform nolog

estimates store noncoviddeath
									
* Set timevar
range timevar 0 105 100
set trace on
m: mata describe using lstandsurv
standsurv, crmodels(coviddeath noncoviddeath) cif ci timevar(timevar) verbose ///
	at1(exposure 0) at2(exposure 1) atvar(F_unexposed F_exposed) ///
	contrast(difference) contrastvar(cif_diff)


* Plot the standardised cause-sepcific CIFs
twoway  (rarea F_unexposed_coviddeath_lci F_unexposed_coviddeath_uci timevar, color(red%30)) ///
         (line F_unexposed_coviddeath timevar, color(red)) ///
         (rarea F_exposed_coviddeath_lci F_exposed_coviddeath_uci timevar, color(blue%30)) ///
         (line F_exposed_coviddeath timevar, color(blue)) ///
, legend(order(2 "Non-current NSAID use" 4 "Current NSAID use") cols(1) ring(0) pos(11)) ///
                 ylabel(, angle(h) format(%4.3f)) ///
                 xtitle("Days from 1 March 2020") ytitle("cause-specific CIF") ///
                 title("Covid-19 death") ///
                 name(coviddeath, replace)
                 
twoway  (rarea F_unexposed_noncoviddeath_lci F_unexposed_noncoviddeath_uci timevar, color(red%30)) ///
         (line F_unexposed_noncoviddeath timevar, color(red)) ///
         (rarea F_exposed_noncoviddeath_lci F_exposed_noncoviddeath_uci timevar, color(blue%30)) ///
         (line F_exposed_noncoviddeath timevar, color(blue)) ///
                 , legend(order(2 "Non-current NSAID use" 4 "Current NSAID use") cols(1) ring(0) pos(11)) ///
                 ylabel(, angle(h) format(%4.3f)) ///
                 xtitle("Days from 1 March 2020") ytitle("cause-specific CIF") ///
                 title("Non Covid-19 death") ///
                 name(noncoviddeath, replace)

graph combine coviddeath noncoviddeath, nocopies ycommon
				 
graph export "$outdir/Adj_survival_curves_2.svg", as(svg) replace

* Close window 
graph close


* Plot the difference in curves
twoway  (rarea cif_diff_coviddeath_lci cif_diff_coviddeath_uci timevar, color(red%30)) ///
        (line cif_diff_coviddeath timevar, color(red)) ///
                 , legend(off) ///
                 ylabel(, angle(h) format(%4.3f)) ///
                 xtitle("Days from 1 March 2020") ytitle("cause-specific CIF") ///
                 title("Covid-19 death") ///
                 name(coviddeath_diff, replace)
                 
twoway  (rarea cif_diff_noncoviddeath_lci cif_diff_noncoviddeath_uci timevar, color(red%30)) ///
         (line cif_diff_noncoviddeath timevar, color(red)) ///
                 , legend(off) ///
                 ylabel(, angle(h) format(%4.3f)) ///
                 xtitle("Days from 1 March 2020") ytitle("Contrasts") ///
                 title("Non Covid-19 death") ///
                 name(noncoviddeath_diff, replace)

             
graph combine coviddeath_diff noncoviddeath_diff, nocopies ycommon 
				 
graph export "$outdir/difference_survival_curves_2.svg", as(svg) replace

* Close window 
graph close
 
				 
* Close log file 
log close