/*==============================================================================
DO FILE NAME:			12a_an_models_adj_survival_curve_nsaid
PROJECT:				NSAID in COVID-19 
AUTHOR:					A Wong
DATE: 					8 Jul 2020 					
DESCRIPTION OF FILE:	program 12
						Using fully adjusted model
DATASETS USED:			data in memory ($tempdir/analysis_dataset_STSET_outcome)

DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
						Adj_survival_curves.svg
						difference_survival_curves.svg
							
==============================================================================*/
* Open a log file
capture log close
log using $logdir\12a_an_models_adj_survival_curve_nsaid, replace t

* Open Stata dataset
use $tempdir\analysis_dataset_STSET_$outcome, clear

/*==============================================================================*/
* Fit the stpm2 model 
stpm2 exposure male age1 age2 age3  obese4cat				///
									smoke_nomiss		    ///
									imd 					///
									ckd	 					///		
									hypertension			///		
									heart_failure			///		
									other_heart_disease		///		
									diab_control			///	
									copd                    ///
									other_respiratory       ///
									immunodef_any		 	///
									cancer     				///	
									rheumatoid 				///	
									osteoarthritis			///	
									statin 					///	
									ppi                     ///
									steroid_prednisolone    ///
									hydroxychloroquine      ///
									dmards_primary_care     ///
									flu_vaccine 			///	
									pneumococcal_vaccine,   ///
									initstrata(stp) scale(hazard) df(4) eform nolog

* Set timevar
range timevar 0 105 100

* Run stpm2 (not allow to use factor variable)
stpm2_standsurv, at1(exposure 0) at2(exposure 1) timevar(timevar) ci contrast(difference)

* list the standardized curves for longest follow-up, followed by their difference.
list _at1* if timevar==105, noobs
list _at2* if timevar==105, noobs
list _contrast* if timevar==105, noobs ab(16)

* Plot the survival curves
twoway  (rarea _at1_lci _at1_uci timevar, color(red%25)) ///
                (rarea _at2_lci _at2_uci timevar, color(blue%25)) ///
                 (line _at1 timevar, sort lcolor(red)) ///
                 (line _at2  timevar, sort lcolor(blue)) ///
                 , legend(order(1 "Non-current NSAID use" 2 "Current NSAID use") ///
				 ring(0) cols(1) pos(1)) ///
                 ylabel(0.5(0.1)1,angle(h) format(%3.1f)) ///
                 ytitle("S(t)") ///
                 xtitle("Days from 1 March 2020") ///
				 saving(Adj_survival_curves, replace)
				 
graph export "$outdir/Adj_survival_curves.svg", as(svg) replace

* Close window 
graph close

* Delete unneeded graphs
erase Adj_survival_curves.gph

* Plot the difference in curves
twoway  (rarea _contrast2_1_lci _contrast2_1_uci timevar, color(red%25)) ///
                 (line _contrast2_1 timevar, sort lcolor(red)) ///
                 , legend(off) ///
                 ylabel(,angle(h) format(%3.2f)) ///
                 ytitle("Difference in S(t)") ///
                 xtitle("Days from 1 March 2020") ///
				 saving(difference_survival_curves, replace)
				 
graph export "$outdir/difference_survival_curves.svg", as(svg) replace

* Close window 
graph close

* Delete unneeded graphs
erase difference_survival_curves.gph		 
				 
* Close log file 
log close