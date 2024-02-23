****************************************************************************************************************************************************************
*****************************Replication of the first Survey Results
****************************************************************************************************************************************************************

clear all
set scrollbufsize 200000
if c(username)=="WWA835" {


global do_path "C:\Users\WWA835\Dropbox\PC\Desktop\Andere Projekte\Replication_Game\Gsottbauer et al\Survey1" 
global data_path "C:\Users\WWA835\Dropbox\PC\Desktop\Andere Projekte\Replication_Game\Gsottbauer et al\Survey1\Data_Survey1"
global figure_path "C:\Users\WWA835\Dropbox\PC\Desktop\Andere Projekte\Replication_Game\Gsottbauer et al\Survey1\Figures_Survey1" 
cd "$do_path"
}


use "$data_path\masterfile_survey1", clear 


global controls i.male i.age i.edu i.east 

******Generate balancing table -- Table 1
*iebaltab income male age edu married student religiousness east leftright,  grpvar(rich) save("${figure_path}\balancing.xlsx") rowvarlabels replace

*--> Some findings are different? Sample is different at least


******Check Manipulation Check -- Table 2
regress manip i.rich, robust
regress manip i.real_rich, robust
regress manip i.rich##i.real_rich, robust

*--> Table 3 replicates

******Payment in Euros Survey 1 -- Table 4
regress payment i.rich, robust
regress payment i.real_rich, robust
regress payment i.rich##i.real_rich, robust

*--> Table 4 replicates

****************************************************************************************************************************************************************
*****************************Replication of the first Survey Results
****************************************************************************************************************************************************************
******OLS Regressions -- Table 5
clear all
use "$data_path\masterfile_survey1", clear 


global controls i.male i.age i.edu i.east 
global ctrls    "male age edu east" 

****Baseline changes for some reason
gen treatment = 0
replace treatment = 1 if rich == 0
label define treated2  0 "Primed-rich" 1 "Primed-poor"
label values treatment treated2
gen real_rich2 = 0
replace real_rich2 = 1 if real_rich == 0 
replace real_rich2 = . if real_rich == . 
label define rich2 0 "Real-rich" 1 "Real-poor"
label values real_rich2 rich2

********************************************************************************
***************Table 5 Original Author
********************************************************************************
*** Table 5  ***: 
reg payment rich real_rich , robust 
reg payment rich real_rich  $ctrls, robust
reg payment poorprimed_poor poorprimed_rich richprimed_poor, robust 
reg payment poorprimed_poor poorprimed_rich richprimed_poor $ctrls, robust 


********************************************************************************
***************Table 5 without missing imputation
********************************************************************************
label var rich "Primed-rich"
label var real_rich "Real-rich (dummy)"

regress payment i.rich i.real_rich, robust
		eststo
*Model 1 replicates
regress payment i.rich i.real_rich ${controls} , robust
		eststo
		 
*Model 2 has different parameters due to different baseline categories
*Baseline Primed rich real rich
regress payment i.treatment##i.real_rich2, robust

lincom 1.treatment + 1.real_rich2 + 1.treatment#1.real_rich2
estadd scalar primed_poor_real_poor = r(estimate)
estadd scalar primed_poor_real_poor_p = r(p)

lincom 1.treatment
estadd scalar primed_poor_real_rich = r(estimate)
estadd scalar primed_poor_real_rich_p = r(p)

lincom 1.real_rich
estadd scalar primed_rich_real_poor = r(estimate)
estadd scalar primed_rich_real_poor_p = r(p)
		eststo

*Model 3 replicates (aside from some third decimal point differences)

regress payment i.treatment##i.real_rich2 ${controls} , robust

lincom 1.treatment + 1.real_rich2 + 1.treatment#1.real_rich2
estadd scalar primed_poor_real_poor = r(estimate)
estadd scalar primed_poor_real_poor_p = r(p)

lincom 1.treatment
estadd scalar primed_poor_real_rich = r(estimate)
estadd scalar primed_poor_real_rich_p = r(p)

lincom 1.real_rich
estadd scalar primed_rich_real_poor = r(estimate)
estadd scalar primed_rich_real_poor_p = r(p)
		eststo
*Model 4 does changes in some aspects

**********************
esttab using "${figure_path}\Table5_wo_imp.tex", style(tex) booktabs ///
                                ar2 obslast ///
								indicate("Controls = 1.male ") ///
								keep(1.rich 1.real_rich 1.treatment 1.real_rich2 1.treatment#1.real_rich2 ) ///
                                cells(b(star fmt(3)) se(par fmt(3))) dropped nobaselevels label ///
								stats(primed_rich_real_poor primed_rich_real_poor_p primed_poor_real_poor primed_poor_real_poor_p primed_poor_real_rich primed_poor_real_rich_p N, ///
                                labels("Primed-rich x Real-poor" "Primed-rich x Real-poor p-Value" "Primed-poor x Real-poor" "Primed-poor x Real-poor p-Value" ///
								"Primed-poor x Real-rich" "Primed-poor x Real-rich p-Value"  "N") fmt(3 3 3 3 3 3 a2)) ///
                                mtitles("(1)" "(2)" "(3)" "(4)") ///
                                gaps collabels(none) nonumbers starlevels(* 0.10 ** 0.05 *** 0.01) ///
                                postfoot("\bottomrule"  "\end{tabular}" "}") ///
								replace
								
								eststo clear

********************************************************************************
***************Table 5 with missing imputation
********************************************************************************								
								
******Mean imputation and Imputation Dummies for control variables
foreach var in male age edu east {
	gen Imp_dum_`var' = 0
	replace Imp_dum_`var' = 1 if `var' == .
	replace `var' = 999 if `var' == .
}


label var rich "Primed-rich"
label var real_rich "Real-rich (dummy)"

regress payment i.rich i.real_rich, robust
		eststo
*Model 1 replicates
regress payment i.rich i.real_rich ${controls} , robust
		eststo
		 
*Model 2 has different parameters due to different baseline categories
*Baseline Primed rich real rich
regress payment i.treatment##i.real_rich2, robust

lincom 1.treatment + 1.real_rich2 + 1.treatment#1.real_rich2
estadd scalar primed_poor_real_poor = r(estimate)
estadd scalar primed_poor_real_poor_p = r(p)

lincom 1.treatment
estadd scalar primed_poor_real_rich = r(estimate)
estadd scalar primed_poor_real_rich_p = r(p)

lincom 1.real_rich
estadd scalar primed_rich_real_poor = r(estimate)
estadd scalar primed_rich_real_poor_p = r(p)
		eststo

*Model 3 replicates (aside from some third decimal point differences)

regress payment i.treatment##i.real_rich2 ${controls} , robust

lincom 1.treatment + 1.real_rich2 + 1.treatment#1.real_rich2
estadd scalar primed_poor_real_poor = r(estimate)
estadd scalar primed_poor_real_poor_p = r(p)

lincom 1.treatment
estadd scalar primed_poor_real_rich = r(estimate)
estadd scalar primed_poor_real_rich_p = r(p)

lincom 1.real_rich
estadd scalar primed_rich_real_poor = r(estimate)
estadd scalar primed_rich_real_poor_p = r(p)
		eststo
*Model 4 does changes in some aspects

**********************
esttab using "${figure_path}\Table5_w_imp.tex", style(tex) booktabs ///
                                ar2 obslast ///
								indicate("Controls = 1.male ") ///
								keep(1.rich 1.real_rich 1.treatment 1.real_rich2 1.treatment#1.real_rich2 ) ///
                                cells(b(star fmt(3)) se(par fmt(3))) dropped nobaselevels label ///
								stats(primed_rich_real_poor primed_rich_real_poor_p primed_poor_real_poor primed_poor_real_poor_p primed_poor_real_rich primed_poor_real_rich_p N, ///
                                labels("Primed-rich x Real-poor" "Primed-rich x Real-poor p-Value" "Primed-poor x Real-poor" "Primed-poor x Real-poor p-Value" ///
								"Primed-poor x Real-rich" "Primed-poor x Real-rich p-Value"  "N") fmt(3 3 3 3 3 3 a2)) ///
                                mtitles("(1)" "(2)" "(3)" "(4)") ///
                                gaps collabels(none) nonumbers starlevels(* 0.10 ** 0.05 *** 0.01) ///
                                postfoot("\bottomrule"  "\end{tabular}" "}") ///
								replace
								
								eststo clear
								
							
								
reg payment rich real_rich , robust 
reg payment rich real_rich  $ctrls i.Imp_dum_male i.Imp_dum_age i.Imp_dum_edu i.Imp_dum_east, robust

********************************************************************************
***************Table Appendix A2.1
********************************************************************************
****** Check Manipulation 	
clear all
use "$data_path\masterfile_survey1", clear 


global controls i.male i.age i.edu i.east 


******Mean imputation and Imputation Dummies for control variables
foreach var in male age edu east {
	gen Imp_dum_`var' = 0
	replace Imp_dum_`var' = 1 if `var' == .
	replace `var' = 999 if `var' == .
}

label var rich "Primed-rich"
label var real_rich "Real-rich (dummy)"

regress manip i.rich i.real_rich, robust
		eststo
*Model 1 replicates
regress manip i.rich i.real_rich ${controls} , robust
		eststo
		 
****Baseline changes for some reason
gen treatment = 0
replace treatment = 1 if rich == 0
label define treated2  0 "Primed-rich" 1 "Primed-poor"
label values treatment treated2
gen real_rich2 = 0
replace real_rich2 = 1 if real_rich == 0 
replace real_rich2 = . if real_rich == . 
label define rich2 0 "Real-rich" 1 "Real-poor"
label values real_rich2 rich2


*Model 2 has different parameters due to different baseline categories?
*Baseline Primed rich real rich
regress manip i.treatment##i.real_rich2, robust

lincom 1.treatment + 1.real_rich2 + 1.treatment#1.real_rich2
estadd scalar primed_poor_real_poor = r(estimate)
estadd scalar primed_poor_real_poor_p = r(p)

lincom 1.treatment
estadd scalar primed_poor_real_rich = r(estimate)
estadd scalar primed_poor_real_rich_p = r(p)

lincom 1.real_rich
estadd scalar primed_rich_real_poor = r(estimate)
estadd scalar primed_rich_real_poor_p = r(p)
		eststo

*Model 3 replicates (aside from some third decimal point differences)

regress manip i.treatment##i.real_rich2 ${controls} , robust

lincom 1.treatment + 1.real_rich2 + 1.treatment#1.real_rich2
estadd scalar primed_poor_real_poor = r(estimate)
estadd scalar primed_poor_real_poor_p = r(p)

lincom 1.treatment
estadd scalar primed_poor_real_rich = r(estimate)
estadd scalar primed_poor_real_rich_p = r(p)

lincom 1.real_rich
estadd scalar primed_rich_real_poor = r(estimate)
estadd scalar primed_rich_real_poor_p = r(p)
		eststo
*Model 4 does change in some aspects

**********************
esttab using "${figure_path}\Table_A2_1.tex", style(tex) booktabs ///
                                ar2 obslast ///
								indicate("Controls = 1.male ") ///
								keep(1.rich 1.real_rich 1.treatment 1.real_rich2 1.treatment#1.real_rich2 ) ///
                                cells(b(star fmt(3)) se(par fmt(3))) dropped nobaselevels label ///
								stats(primed_rich_real_poor primed_rich_real_poor_p primed_poor_real_poor primed_poor_real_poor_p primed_poor_real_rich primed_poor_real_rich_p N, ///
                                labels("Primed-rich x Real-poor" "Primed-rich x Real-poor p-Value" "Primed-poor x Real-poor" "Primed-poor x Real-poor p-Value" ///
								"Primed-poor x Real-rich" "Primed-poor x Real-rich p-Value"  "N") fmt(3 3 3 3 3 3 a2)) ///
                                mtitles("(1)" "(2)" "(3)" "(4)") ///
                                gaps collabels(none) nonumbers starlevels(* 0.10 ** 0.05 *** 0.01) ///
                                postfoot("\bottomrule"  "\end{tabular}" "}") ///
								replace
								
								eststo clear

************************************************************************************************************************************************************
*****************Replication of Figures in Survey 1
************************************************************************************************************************************************************
*Figure 2
histogram payment, bin(11) percent yline(9.09) title("Histogram of Individual Payments -- Survey 1") ytitle("Percent")
graph export "${figure_path}/Figure2.pdf", replace

*Figure 3
graph bar (mean) payment, over(rich) over(real_rich)

preserve
collapse (mean) mean_pay=payment (sd) sd_pay=payment (count) n=payment, by(rich real_rich)

gen interaction = 1 	if rich == 0 & real_rich == 0	
replace interaction = 2 if rich == 0 & real_rich == 1
replace interaction = 3 if rich == 1 & real_rich == 0
replace interaction = 4 if rich == 1 & real_rich == 1

generate upper = mean_pay + invttail(n-1,0.025)*(sd_pay/sqrt(n))
generate lower  = mean_pay - invttail(n-1,0.025)*(sd_pay/sqrt(n))

twoway (bar mean_pay interaction, color(gs7) barwidth(0.8) ///
xlabel(1 `""Primed Poor" "- Poor""' 2 `""Primed Poor" "- Rich""' 3 `""Primed Rich" "- Poor""'  4 `""Primed Rich" "- Rich""', labsize(vsmall)))  ///
(rcap upper lower interaction), title("Histograms of Payments by Group -- Survey 1") ytitle("Payments in Euros") ysize(5) ylabel(9(1)13, nogrid) xtitle("")

graph export "${figure_path}/Figure3.pdf", replace
restore


************************************************************************************************************************************************************
*****************Replication of Appendix Figures in Survey 1
************************************************************************************************************************************************************
***Figure A3.3
*create quartiles
xtile quartiles= income ,n(4)

*1st quartile
preserve
keep if quartile == 1
histogram payment, bin(11) percent yline(9.09) title("Quartile 1") ytitle("Percent")
graph save "$figure_path\A3_3_1.gph", replace
restore
*2nd quartile
preserve
keep if quartile == 2
histogram payment, bin(11) percent yline(9.09) title("Quartile 2") ytitle("Percent")
graph save "$figure_path\A3_3_2.gph", replace
restore
*3rd quartile
preserve
keep if quartile == 3
histogram payment, bin(11) percent yline(9.09) title("Quartile 3") ytitle("Percent")
graph save "$figure_path\A3_3_3.gph", replace
restore
*4th quartile
preserve
keep if quartile == 4
histogram payment, bin(11) percent yline(9.09) title("Quartile 4") ytitle("Percent")
graph save "$figure_path\A3_3_4.gph", replace
restore

gr combine $figure_path\A3_3_1.gph $figure_path\A3_3_2.gph $figure_path\A3_3_3.gph $figure_path\A3_3_4.gph  
graph export "${figure_path}/FigureA3_3.pdf", replace

*Figure A3.5
preserve
keep if student == 1
histogram payment, bin(11) percent yline(9.09) title("Histogram of Individual Payments Students -- Survey 1") ytitle("Percent")
graph export "${figure_path}/FigureA3_5.pdf", replace
restore
