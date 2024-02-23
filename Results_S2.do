****************************************************************************************************************************************************************
*****************************Replication of the first Survey Results
****************************************************************************************************************************************************************

clear all
set scrollbufsize 200000
if c(username)=="WWA835" {


global do_path "C:\Users\WWA835\Dropbox\PC\Desktop\Andere Projekte\Replication_Game\Gsottbauer et al\Survey2" 
global data_path "C:\Users\WWA835\Dropbox\PC\Desktop\Andere Projekte\Replication_Game\Gsottbauer et al\Replication\Survey2"
global figure_path "C:\Users\WWA835\Dropbox\PC\Desktop\Andere Projekte\Replication_Game\Gsottbauer et al\Replication\Survey2\Figures" 
cd "$do_path"
}


use "$data_path\Online_Data_Survey2", clear 

*****************************************************************************************************************************************************************
******************************Clearing
*****************************************************************************************************************************************************************
/*
drop startdate enddate status ipaddress progress finished recordeddate responseid recipientlastname recipientfirstname /// 
recipientemail externalreference locationlatitude locationlongitude distributionchannel userlanguage cintid			

// I Can't find a documentation for the second survey. I cannot check if the coding here is correct, but i seens consistent with the first survey.

rename q26 consent
drop if consent != 1 

//Gender -- Category
rename q7 male 
replace male = (male==1)

// Age -- Category
rename q8 birth_year_interval
gen age = 88 - birth_year_interval * 5
/* 1	1935-1939
2	1940-1944
3	1945-1949
4	1950-1954
5	1955-1959
6	1960-1964
7	1965-1969
8	1970-1974
9	1975-1979
10	1980-1984
11	1985-1989
12	1990-1994
13	1995-1999
14	2000-2004	*/

//Marital status -- Category
gen married = (q12==1) 


//Income -- Category
rename q37 income_interval
//rename q38 income weiche

gen income = . 
replace income = 75 if income_interval == 1
replace income = 275  if income_interval == 2
replace income = 700 if income_interval == 3
replace income = 1250 if income_interval == 4
replace income = 1750 if income_interval == 5
replace income = 2250 if income_interval == 6
replace income = 2750 if income_interval == 7
replace income = 3250 if income_interval == 8
replace income = 3750 if income_interval == 9
replace income = 4250 if income_interval == 10
replace income = 4275 if income_interval == 11
replace income = 5250 if income_interval == 12
replace income = 5750 if income_interval == 13
replace income = 6750 if income_interval == 14
replace income = 8750 if income_interval == 15 & q38 == 1
replace income = 12500 if income_interval == 15 & q38 == 2
replace income = 17500 if income_interval == 15 & q38 == 3
replace income = 25000 if income_interval == 15 & q38 == 4
replace income = income/1000

gen real_rich = . 
replace real_rich = 1 if income>2 & income < 1000000 
replace real_rich = 0 if income<=2 & income > -99  
label var real_rich "Dummy income>2000 Euro"

rename q30 number_householdmember

rename q31 plz_original
label var plz_original "Postleitzahl"

* Gen East dummy & Bundesland: 
gen plz = real(substr(plz_original,1,1))


gen sa = (plz==0)
label var sa "Sachsen"
gen mv = (plz==1)
label var mv "Meck-Pom"
gen ns = (plz==2)
label var ns "Niedersachsen"
gen he = (plz==3)
label var he "Hessen"
gen nrw =(plz==4) 
gen rl = (plz==5)
label var rl "Rheinland"
gen rp = (plz==6)
label var rp "Pfalz"
gen bw = (plz==7) 
gen ba = (plz==8)
label var ba "OberBayern"
gen fr = (plz==9)
label var fr "Franken"

gen east = (plz==0|plz==1)

rename q32 endgeraet // 1=desktop;2=phone;3=tablet; 4=others
gen desktop = (endgeraet==1)
//g33: welches andere geraet. 


// gen q1_1 - q1_9 : wetter items likert skala   
// q2_1 - q2_9: poor priming 
// q3_1 - q3_9: rich priming 

label var q1_1 "Wetter item_1"
label var q2_1 "Poor prime item_1"
label var q3_1 "Rich prime item_1"


// q4_1 - q4_10: manipulation check 
// q4_1: hoechste stufe
// q4_10: niedrigste stufe
// "ON" indicates the chosen level

gen manip = . 
replace manip = 10 if q4_1 == "On"
replace manip = 9 if q4_2 == "On"
replace manip = 8 if q4_3 == "On"
replace manip = 7 if q4_4 == "On"
replace manip = 6 if q4_5 == "On"
replace manip = 5 if q4_6 == "On"
replace manip = 4 if q4_7 == "On"
replace manip = 3 if q4_8 == "On"
replace manip = 2 if q4_9 == "On"
replace manip = 1 if q4_10 == "On"

label var manip "Manipulation check"


rename q6_1 gluecksrad 

rename q10 edu // higher number more education, except 7 means "anderer schulabschluss"  --> q25  
replace edu = 4 if edu == 7

rename q11 vocation // "hoechste berufliche ausbildung" from 1-12; 11 is phd, 12 is "anderer Abschluss"  -- > q24 

gen student = (vocation==1)
label var student "Studenten Dummy"

rename q14 ideology // 1-11

rename q13 religion  
label var religion "10= very religious "

rename treatment treatment_string  

gen treatment = 1 if treatment_string == "Primed_rich"
replace treatment = 0 if treatment_string == "control"
replace treatment = -1 if treatment_string == "Primed_poor"
label var treatment "-1:poor;0:control;1:rich"

gen rich = (treatment == 1)
label var rich "Treatment indicator: 1=rich prime"

gen neutral = (treatment == 0)
label var neutral "Treatment indicator: 1=control"

gen poor = (treatment == -1)
label var poor "Treatment indicator: 1=poor prime"

rename payoff payment 


*  Dummies analogue to survey 1: 
gen poorprimed_poor = (poor==1 & real_rich ==0)
gen poorprimed_rich = (poor==1 & real_rich ==1)
gen richprimed_poor = (rich==1 & real_rich ==0)
gen richprimed_rich = (rich==1 & real_rich ==1)
gen neutral_poor   = (neutral==1 & real_rich ==0)
gen neutral_rich   = (neutral==1 & real_rich ==1)

save "$data_path\Online_Data_Survey2_cleaned", replace 
*/
************************************************************************************************************************************************************
*****************Replication of Tables in Survey 2
************************************************************************************************************************************************************

clear all 
use "$data_path\Online_Data_Survey2_cleaned"

******** Balancing Check Table
*iebaltab income male age edu married student religion east ideology, grpvar(treatment) save("${figure_path}\balancing2.xlsx") rowvarlabels replace

******** Check Manipulation Check -- Table 6 
reg manip i.real_rich, robust // Constant is Real-poor all
lincom _cons + 1.real_rich  // Real-rich all
	
	
regress manip i.rich, robust 
lincom _cons + 1.rich //Primed rich all
	

reg manip i.neutral, robust
lincom _cons + 1.neutral //Primed neutral all
	

reg manip i.poor, robust
lincom _cons + 1.poor //Primed poor all
	
	
reg manip i.rich##1.real_rich, robust
lincom _cons + 1.rich // Primed rich but real-poor
lincom _cons + 1.rich + 1.real_rich // Not in the table
lincom _cons + 1.rich + 1.real_rich + 1.rich#1.real_rich //Primed rich and real-rich
	
	
reg manip i.neutral##1.real_rich, robust
lincom _cons + 1.neutral //Primed neutral and real-poor
lincom _cons + 1.neutral + 1.real_rich // Not in the table
lincom _cons + 1.neutral + 1.real_rich + 1.neutral#1.real_rich // Primed neutral and real rich
	

reg manip i.poor##1.real_rich, robust
lincom _cons + 1.poor // Primed poor and real-poor
lincom _cons + 1.poor + 1.real_rich // Not in the table
lincom _cons + 1.poor + 1.real_rich + 1.poor#1.real_rich // Primed poor but real-rich
	

******** Check Payments in Euro -- Table 7
reg payment i.real_rich, robust // Constant is Real-poor all
lincom _cons + 1.real_rich  // Real-rich all

regress payment i.rich, robust 
lincom _cons + 1.rich //Primed rich all

reg payment i.neutral, robust
lincom _cons + 1.neutral //Primed neutral all

reg payment i.poor, robust
lincom _cons + 1.poor //Primed poor all

reg payment i.rich##1.real_rich, robust
lincom _cons + 1.rich // Primed rich but real-poor
lincom _cons + 1.rich + 1.real_rich // Not in the table
lincom _cons + 1.rich + 1.real_rich + 1.rich#1.real_rich //Primed rich and real-rich

reg payment i.neutral##1.real_rich, robust
lincom _cons + 1.neutral //Primed neutral and real-poor
lincom _cons + 1.neutral + 1.real_rich // Not in the table
lincom _cons + 1.neutral + 1.real_rich + 1.neutral#1.real_rich // Primed neutral and real rich

reg payment i.poor##1.real_rich, robust
lincom _cons + 1.poor // Primed poor and real-poor
lincom _cons + 1.poor + 1.real_rich // Not in the table
lincom _cons + 1.poor + 1.real_rich + 1.poor#1.real_rich // Primed poor but real-rich


******** Regression for Table 8
 
//Authors just use 9 out of 16 German states
//They also treat Franken as a state which it is not
foreach var in male age edu sa mv ns he nrw rl rp bw ba fr east {
	gen Imp_dum_`var' = 0
	replace Imp_dum_`var' = 1 if `var' == .
	replace `var' = 999 if `var' == .
}

global control i.male i.age i.edu i.sa i.mv i.ns i.he i.nrw i.rl i.rp i.bw i.ba i.fr
global control2 i.male i.age i.edu i.sa i.mv i.ns i.he i.nrw i.rl i.rp i.bw i.ba i.fr i.east

**Create one treatment variable with primed poor as baseline
replace treatment = treatment + 1
label define treated 0 "Primed-poor" 1 "Primed-neutral" 2 "Primed-rich"
label values treatment treated
label define rich 0 "Real-poor" 1 "Real-rich"
label values real_rich rich

///Here the authors change baseline categrory? -- Now primed rich real rich?
gen treatment2 = 0
replace treatment2 = 2 if treatment == 0 
replace treatment2 = 1 if treatment == 1
label define treated2  0 "Primed-rich" 1 "Primed-neutral" 2 "Primed-poor"
label values treatment2 treated2
gen real_rich2 = 0
replace real_rich2 = 1 if real_rich == 0
label define rich2 0 "Real-rich" 1 "Real-poor"
label values real_rich2 rich2

*Model 1
reg payment i.treatment i.real_rich, robust
		eststo
*Model 2
reg payment i.treatment i.real_rich ${control}, robust 
		eststo
 
*Model 3
reg payment i.treatment2##i.real_rich2, robust
//Primed poor x real poor
lincom 2.treatment2 + 2.treatment2#1.real_rich2 + 1.real_rich2
estadd scalar primed_poor_real_poor = r(estimate)
estadd scalar primed_poor_real_poor_p = r(p)
//Primed poor x real rich
lincom 2.treatment 
estadd scalar primed_poor_real_rich = r(estimate)
estadd scalar primed_poor_real_rich_p = r(p)
//Primed neutral x real poor
lincom 1.treatment + 1.treatment2#1.real_rich2 + 1.real_rich2
estadd scalar primed_neutral_real_poor = r(estimate)
estadd scalar primed_neutral_real_poor_p = r(p)
//Primed neutral x real rich
lincom 1.treatment 
estadd scalar primed_neutral_real_rich = r(estimate)
estadd scalar primed_neutral_real_rich_p = r(p)
//Primed rich x real poor
lincom 1.real_rich2
estadd scalar primed_rich_real_poor = r(estimate)
estadd scalar primed_rich_real_poor_p = r(p)
		eststo

reg payment i.treatment2##i.real_rich2 ${control}, robust
//Primed poor x real poor
lincom 2.treatment2 + 2.treatment2#1.real_rich2 + 1.real_rich2
estadd scalar primed_poor_real_poor = r(estimate)
estadd scalar primed_poor_real_poor_p = r(p)
//Primed poor x real rich
lincom 2.treatment 
estadd scalar primed_poor_real_rich = r(estimate)
estadd scalar primed_poor_real_rich_p = r(p)
//Primed neutral x real poor
lincom 1.treatment + 1.treatment2#1.real_rich2 + 1.real_rich2
estadd scalar primed_neutral_real_poor = r(estimate)
estadd scalar primed_neutral_real_poor_p = r(p)
//Primed neutral x real rich
lincom 1.treatment 
estadd scalar primed_neutral_real_rich = r(estimate)
estadd scalar primed_neutral_real_rich_p = r(p)
//Primed rich x real poor
lincom 1.real_rich2
estadd scalar primed_rich_real_poor = r(estimate)
estadd scalar primed_rich_real_poor_p = r(p)
		eststo

esttab using "${figure_path}\Table8.tex", style(tex) booktabs ///
                                ar2 obslast ///
								indicate("Controls = 1.male ") ///
								keep(1.treatment 2.treatment 1.real_rich 1.treatment 2.treatment2 1.treatment2#1.real_rich2 2.treatment2#1.real_rich2 1.real_rich2) ///
                                cells(b(star fmt(3)) se(par fmt(3))) dropped nobaselevels label ///
								stats(primed_poor_real_poor primed_poor_real_poor_p primed_poor_real_rich primed_poor_real_rich_p ///
								primed_neutral_real_poor primed_neutral_real_poor_p primed_neutral_real_rich primed_neutral_real_rich_p primed_rich_real_poor primed_rich_real_poor_p N, ///
                                labels("Primed-poor x Real-poor" "Primed-poor x Real-poor p-Value" "Primed-poor x Real-rich" "Primed-poor x Real-rich p-Value" ///
								"Primed-neutral x Real-poor" "Primed-neutral x Real-poor p-Value" "Primed-neutral x Real-rich" "Primed-neutral x Real-rich p-Value" ///
								"Primed-rich x Real-poor" "Primed-rich x Real-poor p-Value" "N") ///
								fmt(3 3 3 3 3 a2)) ///
                                mtitles("(1)" "(2)" "(3)" "(4)") ///
                                gaps collabels(none) nonumbers starlevels(* 0.10 ** 0.05 *** 0.01) ///
                                postfoot("\bottomrule"  "\end{tabular}" "}") ///
								replace
								
								eststo clear

*Author original

reg payment rich neutral real_rich , robust 
reg payment rich neutral real_rich  $ctrls, robust
reg payment poorprimed_poor poorprimed_rich richprimed_poor neutral_rich neutral_poor 	, robust   //  richprimed_rich
reg payment poorprimed_poor poorprimed_rich richprimed_poor neutral_rich neutral_poor  $ctrls, robust	// richprimed_rich
								
****** Check Manipulation -- Table Appendix A2.2	
*Model 1
reg manip i.treatment i.real_rich, robust
		eststo
*Model 2
reg manip i.treatment i.real_rich ${control}, robust 
		eststo
 
*Model 3
reg manip i.treatment2##i.real_rich2, robust
//Primed poor x real poor
lincom 2.treatment2 + 2.treatment2#1.real_rich2 + 1.real_rich2
estadd scalar primed_poor_real_poor = r(estimate)
//Primed poor x real rich
lincom 2.treatment 
estadd scalar primed_poor_real_rich = r(estimate)
//Primed neutral x real poor
lincom 1.treatment + 1.treatment2#1.real_rich2 + 1.real_rich2
estadd scalar primed_neutral_real_poor = r(estimate)
//Primed neutral x real rich
lincom 1.treatment 
estadd scalar primed_neutral_real_rich = r(estimate)
//Primed rich x real poor
lincom 1.real_rich2
estadd scalar primed_rich_real_poor = r(estimate)
		eststo

reg manip i.treatment2##i.real_rich2 ${control}, robust
//Primed poor x real poor
lincom 2.treatment2 + 2.treatment2#1.real_rich2 + 1.real_rich2
estadd scalar primed_poor_real_poor = r(estimate)
//Primed poor x real rich
lincom 2.treatment 
estadd scalar primed_poor_real_rich = r(estimate)
//Primed neutral x real poor
lincom 1.treatment + 1.treatment2#1.real_rich2 + 1.real_rich2
estadd scalar primed_neutral_real_poor = r(estimate)
//Primed neutral x real rich
lincom 1.treatment 
estadd scalar primed_neutral_real_rich = r(estimate)
//Primed rich x real poor
lincom 1.real_rich2
estadd scalar primed_rich_real_poor= r(estimate)
		eststo

esttab using "${figure_path}\Table_A2_2.tex", style(tex) booktabs ///
                                ar2 obslast ///
								indicate("Controls = 1.male ") ///
								keep(1.treatment 2.treatment 1.real_rich 1.treatment 2.treatment2 1.treatment2#1.real_rich2 2.treatment2#1.real_rich2 1.real_rich2) ///
                                cells(b(star fmt(3)) se(par fmt(3))) dropped nobaselevels label ///
								stats(primed_poor_real_poor primed_poor_real_rich primed_neutral_real_poor primed_neutral_real_rich primed_rich_real_poor N, ///
                                labels("Primed-poor x Real-poor" "Primed-poor x Real-rich" "Primed-neutral x Real-poor" "Primed-neutral x Real-rich" "Primed-rich x Real-poor" "N") fmt(3 3 3 3 3 a2)) ///
                                mtitles("(1)" "(2)" "(3)" "(4)") ///
                                gaps collabels(none) nonumbers starlevels(* 0.10 ** 0.05 *** 0.01) ///
                                postfoot("\bottomrule"  "\end{tabular}" "}") ///
								replace
								
								eststo clear


************************************************************************************************************************************************************
*****************Replication of Figures in Survey 2
************************************************************************************************************************************************************
*Figure 4
histogram payment, bin(11) percent yline(9.09) title("Histogram of Individual Payments -- Survey2") ytitle("Percent")
graph export "${figure_path}/Figure4.pdf", replace

*Figure 5
graph bar (mean) payment, over(treatment) over(real_rich)

preserve
collapse (mean) mean_pay=payment (sd) sd_pay=payment (count) n=payment, by(treatment real_rich)

gen interaction = 1 	if treatment == 0 & real_rich == 0	
replace interaction = 2 if treatment == 0 & real_rich == 1
replace interaction = 3 if treatment == 1 & real_rich == 0 
replace interaction = 4 if treatment == 1 & real_rich == 1	
replace interaction = 5 if treatment == 2 & real_rich == 0
replace interaction = 6 if treatment == 2 & real_rich == 1

generate upper = mean_pay + invttail(n-1,0.025)*(sd_pay/sqrt(n))
generate lower  = mean_pay - invttail(n-1,0.025)*(sd_pay/sqrt(n))

twoway (bar mean_pay interaction, color(gs7) barwidth(0.8) ///
xlabel(1 `""Primed Poor" "- Poor""' 2 `""Primed Poor" "- Rich""' 3 `""Neutral" "- Poor""'  4 `""Neutral" "- Rich""' 5 `""Primed Rich" "- Poor""'  6 `""Primed Rich" "- Rich""', labsize(vsmall)))  ///
(rcap upper lower interaction), title("Histograms of Payments by Group -- Survey2") ytitle("Payments in Euros") ysize(5) ylabel(9(1)13, nogrid) xtitle("")
graph export "${figure_path}/Figure5.pdf", replace
restore


************************************************************************************************************************************************************
*****************Replication of Appendix Figures in Survey 2
************************************************************************************************************************************************************

***Figure A3.4
*create quartiles
xtile quartiles= income ,n(4)

*1st quartile
preserve
keep if quartile == 1
histogram payment, bin(11) percent yline(9.09) title("Quartile 1") ytitle("Percent")
graph save "$figure_path\A3_4_1.gph", replace
restore
*2nd quartile
preserve
keep if quartile == 2
histogram payment, bin(11) percent yline(9.09) title("Quartile 2") ytitle("Percent")
graph save "$figure_path\A3_4_2.gph", replace
restore
*3rd quartile
preserve
keep if quartile == 3
histogram payment, bin(11) percent yline(9.09) title("Quartile 3") ytitle("Percent")
graph save "$figure_path\A3_4_3.gph", replace
restore
*4th quartile
preserve
keep if quartile == 4
histogram payment, bin(11) percent yline(9.09) title("Quartile 4") ytitle("Percent")
graph save "$figure_path\A3_4_4.gph", replace
restore

gr combine $figure_path\A3_4_1.gph $figure_path\A3_4_2.gph $figure_path\A3_4_3.gph $figure_path\A3_4_4.gph  
graph export "${figure_path}/FigureA3_4.pdf", replace

*Figure A3.6
preserve
keep if student == 1
histogram payment, bin(11) percent yline(9.09) title("Histogram of Individual Payments Students -- Survey 2") ytitle("Percent")
graph export "${figure_path}/FigureA3_6.pdf", replace
restore

************************************************************************************************************************************************************
*****************Different income cut-off
************************************************************************************************************************************************************
clear all 
use "$data_path\Online_Data_Survey2_cleaned"

*****Create one treatment variable with primed poor as baseline
replace treatment = treatment + 1
label define treated 0 "Primed-poor" 1 "Primed-neutral" 2 "Primed-rich"
label values treatment treated

*****Create one treatment variable with primed rich as baseline
gen treatment2 = 0
replace treatment2 = 2 if treatment == 0 
replace treatment2 = 1 if treatment == 1
label define treated2  0 "Primed-rich" 1 "Primed-neutral" 2 "Primed-poor"
label values treatment2 treated2

*****Real-Rich with poor as baseline
label define rich 0 "Real-poor" 1 "Real-rich"
label values real_rich rich
gen real_rich3 = 0
replace real_rich3 = 1 if income >= 3
label values real_rich3 rich

****Real-Rich with rich as baseline
gen real_rich4 = 0
replace real_rich4 = 1 if real_rich3 == 0
label define rich4 0 "Real-rich" 1 "Real-poor"
label values real_rich4 rich4

*Model 1
reg payment i.treatment i.real_rich3, robust
		eststo
*Model 2
reg payment i.treatment i.real_rich3 ${control}, robust 
		eststo
 
*Model 3
reg payment i.treatment2##i.real_rich4, robust
//Primed poor x real poor
lincom 2.treatment2 + 2.treatment2#1.real_rich4 + 1.real_rich4
estadd scalar primed_poor_real_poor = r(estimate)
//Primed poor x real rich
lincom 2.treatment 
estadd scalar primed_poor_real_rich = r(estimate)
//Primed neutral x real poor
lincom 1.treatment + 1.treatment2#1.real_rich4 + 1.real_rich4
estadd scalar primed_neutral_real_poor = r(estimate)
//Primed neutral x real rich
lincom 1.treatment 
estadd scalar primed_neutral_real_rich = r(estimate)
//Primed rich x real poor
lincom 1.real_rich4
estadd scalar primed_rich_real_poor = r(estimate)
		eststo

reg payment i.treatment2##i.real_rich4 ${control}, robust
//Primed poor x real poor
lincom 2.treatment2 + 2.treatment2#1.real_rich4 + 1.real_rich4
estadd scalar primed_poor_real_poor = r(estimate)
//Primed poor x real rich
lincom 2.treatment 
estadd scalar primed_poor_real_rich = r(estimate)
//Primed neutral x real poor
lincom 1.treatment + 1.treatment2#1.real_rich4 + 1.real_rich4
estadd scalar primed_neutral_real_poor = r(estimate)
//Primed neutral x real rich
lincom 1.treatment 
estadd scalar primed_neutral_real_rich = r(estimate)
//Primed rich x real poor
lincom 1.real_rich4
estadd scalar primed_rich_real_poor= r(estimate)
		eststo

esttab using "${figure_path}\Table8-check.tex", style(tex) booktabs ///
                                ar2 obslast ///
								indicate("Controls = 1.male ") ///
								keep(1.treatment 2.treatment 1.real_rich3 1.treatment 2.treatment2 1.treatment2#1.real_rich4 2.treatment2#1.real_rich4 1.real_rich4) ///
                                cells(b(star fmt(3)) se(par fmt(3))) dropped nobaselevels label ///
								stats(primed_poor_real_poor primed_poor_real_rich primed_neutral_real_poor primed_neutral_real_rich primed_rich_real_poor N, ///
                                labels("Primed-poor x Real-poor" "Primed-poor x Real-rich" "Primed-neutral x Real-poor" "Primed-neutral x Real-rich" "Primed-rich x Real-poor" "N") fmt(3 3 3 3 3 a2)) ///
                                mtitles("(1)" "(2)" "(3)" "(4)") ///
                                gaps collabels(none) nonumbers starlevels(* 0.10 ** 0.05 *** 0.01) ///
                                postfoot("\bottomrule"  "\end{tabular}" "}") ///
								replace
								
								eststo clear
								
************************************************************************************************************************************************************
*****************Self-perceived rich instead of real rich
************************************************************************************************************************************************************

******Perceived rich with poor as baseline
gen p_rich = 0
replace p_rich = 1 if manip > 5
label define prich 0 "Perceived-poor" 1 "Perceived-rich"
label values p_rich prich

*****Perceived rich with rich as baseline
gen p_rich2 = 0
replace p_rich2 = 1 if p_rich == 0
label define prich2 0 "Perceived-rich" 1 "Perceived-poor"
label values p_rich2 prich2


*Model 1
reg payment i.treatment i.p_rich, robust
		eststo
*Model 2
reg payment i.treatment i.p_rich ${control}, robust 
		eststo
 
*Model 3
reg payment i.treatment2##i.p_rich2, robust
//Primed poor x self perceived poor
lincom 2.treatment2 + 2.treatment2#1.p_rich2 + 1.p_rich2
estadd scalar primed_poor_p_poor = r(estimate)
estadd scalar primed_poor_p_poor_p = r(p)
//Primed poor x self perceived rich
lincom 2.treatment 
estadd scalar primed_poor_p_rich = r(estimate)
estadd scalar primed_poor_p_rich_p = r(p)
//Primed neutral x self perceived poor
lincom 1.treatment + 1.treatment2#1.p_rich2 + 1.p_rich2
estadd scalar primed_neutral_p_poor = r(estimate)
estadd scalar primed_neutral_p_poor_p = r(p)
//Primed neutral x self perceived rich
lincom 1.treatment 
estadd scalar primed_neutral_p_rich = r(estimate)
estadd scalar primed_neutral_p_rich_p = r(p)
//Primed rich x self perceived poor
lincom 1.p_rich2
estadd scalar primed_rich_p_poor = r(estimate)
estadd scalar primed_rich_p_poor_p = r(p)
		eststo

reg payment i.treatment2##i.p_rich2 ${control}, robust
//Primed poor x self perceived poor
lincom 2.treatment2 + 2.treatment2#1.p_rich2 + 1.p_rich2
estadd scalar primed_poor_p_poor = r(estimate)
estadd scalar primed_poor_p_poor_p = r(p)
//Primed poor x self perceived rich
lincom 2.treatment 
estadd scalar primed_poor_p_rich = r(estimate)
estadd scalar primed_poor_p_rich_p = r(p)
//Primed neutral x self perceived poor
lincom 1.treatment + 1.treatment2#1.p_rich2 + 1.p_rich2
estadd scalar primed_neutral_p_poor = r(estimate)
estadd scalar primed_neutral_p_poor_p = r(p)
//Primed neutral x self perceived rich
lincom 1.treatment 
estadd scalar primed_neutral_p_rich = r(estimate)
estadd scalar primed_neutral_p_rich_p = r(p)
//Primed rich x self perceived poor
lincom 1.p_rich2
estadd scalar primed_rich_p_poor= r(estimate)
estadd scalar primed_rich_p_poor_p = r(p)
		eststo

esttab using "${figure_path}\Table8-Perceived_Rich.tex", style(tex) booktabs ///
                                ar2 obslast ///
								indicate("Controls = 1.male ") ///
								keep(1.treatment 2.treatment 1.p_rich 1.treatment 2.treatment2 1.treatment2#1.p_rich2 2.treatment2#1.p_rich2 1.p_rich2) ///
                                cells(b(star fmt(3)) se(par fmt(3))) dropped nobaselevels label ///
								stats(primed_poor_p_poor primed_poor_p_poor_p primed_poor_p_rich primed_poor_p_rich_p  primed_neutral_p_rich primed_neutral_p_rich_p ///
								primed_neutral_p_poor primed_neutral_p_poor_p primed_rich_p_poor primed_rich_p_poor_p N, ///
                                labels("Primed-poor x Perceived-poor" "Primed-poor x Perceived-poor - p"  "Primed-poor x Perceived-rich" "Primed-poor x Perceived-rich - p"  ///
								"Primed-neutral x Perceived-rich" "Primed-neutral x Perceived-rich - p" "Primed-neutral x Perceived-poor" "Primed-neutral x Perceived-poor - p"  ///
								"Primed-rich x Perceived-poor" "Primed-rich x Perceived-poor - p" "N") fmt(3 3 3 3 3 a2)) ///
                                mtitles("(1)" "(2)" "(3)" "(4)") ///
                                gaps collabels(none) nonumbers starlevels(* 0.10 ** 0.05 *** 0.01) ///
                                postfoot("\bottomrule"  "\end{tabular}" "}") ///
								replace
								
								eststo clear


