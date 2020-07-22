/*==============================================================================
DO FILE NAME:			05_an_descriptive_plots
PROJECT:				NSAID in COVID-19 
DATE: 					15 June 2020 
AUTHOR:					A Wong (modified from ICS study by A Schultze)
DATE: 					23 Jun 2020 
DESCRIPTION OF FILE:	create KM plot
						save KM plot 
						
DATASETS USED:			$tempdir\analysis_dataset_STSET_onscoviddeath.dta
DATASETS CREATED: 		None
OTHER OUTPUT: 			Results in svg: $outdir\kmplot1
						Log file: $logdir\05_an_descriptive_plots_nsaid 
						
==============================================================================*/

* Open a log file
capture log close
log using $logdir\05_an_descriptive_plots, replace t

* Open Stata dataset
use $tempdir\analysis_dataset_STSET_$outcome, clear

/* Sense check outcomes=======================================================*/ 
tab exposure $outcome

/* Generate KM PLOT===========================================================*/ 

noi display "RUNNING THE KM PLOT FOR `r(N)' "

sts graph, by(exposure) failure 							    			///	
		   title("Time to death, $population population", justification(left) size(medsmall) )  	   ///
		   xtitle("Days since 1 Mar 2020", size(small))						///
		   yscale(range(0, 0.001)) 											///
		   ylabel(0 (0.0005) $km_ymax, angle(0) format(%4.4f) labsize(small))	///
		   xscale(range(30, 84)) 											///
		   xlabel(0 (20) 110, labsize(small))				   				///				
		   legend(size(vsmall) label(1 "Non-current exposure to NSAIDs") label (2 "Current exposure to NSAIDs") region(lwidth(none)) order(2 1) position(12))	///
		   graphregion(fcolor(white)) ///	
		   risktable(,size(vsmall) order (1 "Non-current exposure to NSAIDs" 2 "Current exposure to NSAIDs") title(,size(vsmall))) ///
		   saving(kmplot1, replace) 

graph export "$outdir/kmplot1.svg", as(svg) replace

* Close window 
graph close

* Delete unneeded graphs
erase kmplot1.gph

* Close log file 
log close














