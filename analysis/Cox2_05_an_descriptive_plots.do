/*==============================================================================
DO FILE NAME:			Cox2_05_an_descriptive_plots
PROJECT:				NSAID in COVID-19 
AUTHOR:					A Wong (modified from ICS study by A Schultze)
DATE: 					5 Jul 2020 
DESCRIPTION OF FILE:	create KM plot
						save KM plot 
						
DATASETS USED:			$tempdir\analysis_dataset_STSET_onscoviddeath.dta
DATASETS CREATED: 		None
OTHER OUTPUT: 			Results in svg: $outdir\kmplot3
						
==============================================================================*/

* Open a log file
capture log close
log using $logdir\Cox2_05_an_descriptive_plots, replace t

* Open Stata dataset
use $tempdir\analysis_dataset_STSET_$outcome, clear

/* Sense check outcomes=======================================================*/ 
drop exposure
rename cox_nsaid exposure
tab exposure $outcome

/* Generate KM PLOT===========================================================*/ 

noi display "RUNNING THE KM PLOT FOR `r(N)' "

sts graph, by(exposure) failure 							    			///	
		   title("Time to death, $population population", justification(left) size(medsmall) )  	   ///
		   xtitle("Days since 1 Mar 2020", size(small))						///
		   yscale(range(0, 0.001)) 											///
		   ylabel(0 (0.001) 0.005, angle(0) format(%4.3f) labsize(small))	///
		   xscale(range(30, 84)) 											///
		   xlabel(0 (20) 110, labsize(small))				   				///				
		   legend(size(vsmall) label(1 "Non-current exposure to NSAIDs") label(2 "Cox-2 specific NSAIDs") label(3 "Other specific NSAIDs")         ///
		   region(lwidth(none)) position(12))	///
		   graphregion(fcolor(white)) ///	
		   risktable(,size(vsmall) order (1 "Non-current exposure to NSAIDs" 2 "Cox-2 specific NSAIDs" 3 "Other specific NSAIDs") title(,size(vsmall))) ///
		   saving(kmplot3, replace) 

graph export "$outdir/kmplot3.svg", as(svg) replace

* Close window 
graph close

* Delete unneeded graphs
erase kmplot3.gph

* Close log file 
log close














