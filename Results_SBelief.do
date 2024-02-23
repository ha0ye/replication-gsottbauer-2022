clear all 
set more off 
set scheme s2mono

* Define paths: 
global do_path "C:\Users\WWA835\Dropbox\PC\Desktop\Learning\Replication_Game\Replication\Belief_Survey"
//global paper_path "....\Paper"
global data_file "C:\Users\WWA835\Dropbox\PC\Desktop\Learning\Replication_Game\SurveyBelief\Data_SurveyBelief\SurveyBelief.dta"


******* Data Cleaning SurveyBelief 	***
 
use $data_file, clear 

drop startdate enddate status ipaddress progress finished recordeddate responseid recipientlastname recipientfirstname /// 
recipientemail externalreference locationlatitude locationlongitude distributionchannel userlanguage cintid			

*Gen dummy rich
gen real_rich = 0 
replace real_rich = 1 if income>5
label var real_rich "Dummy income>2000 Euro"

************ Social Class and Ethical Behavior	***************
************ SurveyBelief: Summary Statistics and Tests	*************

** Summary Table 9 ***
*Column 1
tabulate belief_binary
summarize belief_continous
summarize moral

*Column 2 and 3
sort real_rich
by real_rich: tabulate belief_binary
by real_rich: summarize belief_continous
by real_rich: summarize moral

** Corresponding Tests ** 
tabulate belief_binary real_rich, chi2
ranksum belief_continous, by(real_rich)
ranksum moral, by(real_rich)
