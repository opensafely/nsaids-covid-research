**************************
/* Set output directory */
**************************

glob OUTPUT_DIR = ""

****************************
/* Input effect estimates */
****************************

* Study 2 - Adjusted
glob hr_s2 = 0.78
glob lci_s2 = 0.65
glob uci_s2 = 0.95


**************************
/* Create e-value plots */
**************************

/* Study 2 - Adjusted */

evalue hr $hr_s2, lcl($lci_s2) ucl($uci_s2) figure(scheme("s1color") aspect(1.01) ytitle(,size(small) margin(medium)) xtitle(,size(small) margin(medium)) legend(order(1 "Bound for point estimate" 2 "Bound for upper CI") size(small) ring(0) bplacement(neast) cols(1) on textfirst)) 

graph save "${OUTPUT_DIR}evalue_s2adj.gph", replace
graph export "${OUTPUT_DIR}evalue_s2adj.jpg", replace quality(100) width(1000)
