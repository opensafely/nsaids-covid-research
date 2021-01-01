/*=========================================================================
DO FILE NAME:			gr_forestplot_nsaid

AUTHOR:					Angel Wong	
												s
VERSION:				v1

DATE VERSION CREATED: 	2020-Jul-20
					
DESCRIPTION OF FILE:	Aim: To generate forest plots for NSAID study
                        (manually input data to csv files)
*=========================================================================*/

**********************************************************************
***NSAID prescribed cohort
**********************************************************************
import excel "D:\nsaids-covid-research\analysis\forest_plot_nsaid.xlsx", sheet("nsaid_population") cellrange(A1:F16) firstrow clear


gen log_est = log(est)
gen log_lci = log(lci)
gen log_uci = log(uci)
*********************************************************************

metan log_est log_lci log_uci, eform random ///
lcols(Analysis Exposure) olineopt(lpattern(dash) ///
lwidth(vthin)) diamopt(lcolor(blue)) ///
nowarning nobox effect(Hazard Ratio) by(analysis) xlab (.25,.5,1,2,4)  ///
graphregion(color(white)) nosubgroup nooverall texts(100) astext(70)
graph export "D:\nsaids-covid-research\output\nsaid_forest_plot.svg", as(svg) replace
*********************************************************************

**********************************************************************
***Rheumatoid arthritis/ Osteoarthritis cohort
**********************************************************************
import excel "D:\nsaids-covid-research\analysis\forest_plot_nsaid.xlsx", sheet("oa_ra_population") cellrange(A1:F16) firstrow clear


gen log_est = log(est)
gen log_lci = log(lci)
gen log_uci = log(uci)
*********************************************************************

metan log_est log_lci log_uci, eform random ///
lcols(Analysis Exposure) olineopt(lpattern(dash) ///
lwidth(vthin)) diamopt(lcolor(blue)) ///
nowarning nobox effect(Hazard Ratio) by(analysis) xlab (.25,.5,1,2,4)  ///
graphregion(color(white)) nosubgroup nooverall texts(100) astext(70)
graph export "D:\nsaids-covid-research\output\oa_ra_forest_plot.svg", as(svg) replace
*********************************************************************
