clear
drop _all

global home "C:\Users\colin\OneDrive\Documents\UConn\Fourth Semester\Graduate Health Economics\Replication\Data"
global output "C:\Users\colin\OneDrive\Documents\UConn\Fourth Semester\Graduate Health Economics\Replication\Data"
global data "C:\Users\colin\OneDrive\Documents\UConn\Fourth Semester\Graduate Health Economics\Replication\Data"
*sets the proper paths

use "$data\2015.dta"
*opens initial dataset

generate lastden3 = .
*I am not too sure why I have this here, but at this point I am too scared to move it

keep(genhlth _llcpwt lastden3 hhadult qstver hlthpln1 checkup1 flushot6 hivtst6 profexam _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfbing5 _rfdrhv5 _totinda _bmi5 _rfbmi5 physhlth menthlth poorhlth imonth _state expansion year children numadult)
append using "$data\2014.dta", keep(genhlth _llcpwt lastden3 hhadult qstver hlthpln1 checkup1 flushot6 hivtst6 profexam _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfbing5 _rfdrhv5 _totinda _bmi5 _rfbmi5 physhlth menthlth poorhlth imonth _state expansion year children numadult)
append using "$data\2013.dta", keep(genhlth _llcpwt qstver hlthpln1 checkup1 flushot6 hivtst6 profexam _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfbing5 _rfdrhv5 _totinda _bmi5 _rfbmi5 physhlth menthlth poorhlth imonth _state expansion year children numadult)
append using "$data\2012.dta", keep(genhlth _llcpwt lastden3 qstver hlthpln1 checkup1 flushot6 hivtst6 profexam _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfbing5 _rfdrhv5 _totinda _bmi5 _rfbmi5 physhlth menthlth poorhlth imonth _state expansion year children numadult)
append using "$data\2011.dta", keep(genhlth _llcpwt qstver hlthpln1 checkup1 flushot6 hivtst6 profexam _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfbing5 _rfdrhv5 _totinda _bmi5 _rfbmi5 physhlth menthlth poorhlth imonth _state expansion year children numadult)
append using "$data\2010.dta", keep(genhlth _llcpwt lastden3  hlthpln1 checkup1 flushot6 hivtst6 profexam _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfbing5 _rfdrhv5 _totinda _bmi5 _rfbmi5 physhlth menthlth poorhlth imonth _state expansion year children numadult)
*appends 2010-2015 data together

destring imonth, replace
*floats imonth

drop if year == 2011 & imonth >= 7
drop if income2 == 77 | income2 == 99 | income2 == .
*drops invalid observations

generate expansion_post_2014 = 1
replace expansion_post_2014 = 0 if expansion == 4
replace expansion_post_2014 = 0 if year < 2014
replace expansion_post_2014 = 0 if _state == 2 & year <= 2015 & imonth < 10
replace expansion_post_2014 = 0 if _state == 18 & year <= 2015 & imonth < 4
replace expansion_post_2014 = 0 if _state == 26 & year <= 2014 & imonth < 7
replace expansion_post_2014 = 0 if _state == 33 & year <= 2014 & imonth < 10
replace expansion_post_2014 = 0 if _state == 42 & year <= 2015 & imonth < 7
*generates proper expansion dummies

generate years_educ = 0
replace years_educ = 8 if educa == 2
replace years_educ = 11 if educa == 3
replace years_educ = 12 if educa == 4
replace years_educ = 15 if educa == 5
replace years_educ = 16 if educa == 6
*education dummies

replace numadult = hhadult if numadult == . & qstver >= 20 & year >= 2014
replace numadult = 1 if numadult == . & qstver >= 20 & year <= 2013
*I hate how this data is coded

generate married = 0
replace married = 1 if marital == 1
*Married Dummy

replace children = 0 if children == 88 | children == 99 | children == .
*cleans children variable

generate employment = 0
replace employment = 1 if employ1 == 1 | employ1 == 2
*Employment Dummy

generate unemployment = 0
replace unemployment = 1 if employ1 == 3 | employ1 == 4
*Unemployment Dummy

generate male = 1
replace male = 0 if sex == 2
*Male Dummy

generate female = 1
replace female = 0 if sex == 1
*Female Dummy

generate lowincome = 0
replace lowincome = 1 if income2 <= 2
*Low income Dummy

generate elderly = 0
replace elderly = 1 if _age80 >= 65
replace elderly = . if _age80 == .
*Elderly Dummy

generate childless = 0
replace childless = 1 if children == 0
*Childless dummy

generate expansion_dummy = 1
replace expansion_dummy  = 0 if expansion == 4
*Indicates if a state ever expanded Medicare

generate white = 0
replace white = 1 if _race == 1
*White Dummy

generate black = 0
replace black = 1 if _race == 2
*Black Dummy

generate native_american = 0
replace native_american = 1 if _race == 3
*Native American Dummy

generate asian = 0
replace asian = 1 if _race == 4
*Asian Dummy

generate hawaiian = 0
replace hawaiian = 1 if _race == 5
*Hawaiian Dummy

generate other = 0
replace other = 1 if _race == 6
*Other race Dummy

generate multiracial = 0
replace multiracial = 1 if _race == 7
*Multiracial Dummy

generate hispanic = 0
replace hispanic = 1 if _race == 8
*Hispanic Dummy

generate checkup = 0 
replace checkup = 1 if checkup1 == 1
*Check up Dummy

generate flushot = 0
replace flushot = 1 if flushot6 == 1
*Flu shot dummy

generate hivtest = 0
replace hivtest = 1 if hivtst6 == 1
*HIV Test Dummy

generate dental = 0
replace dental = 1 if lastden3 == 1
*dental dummy

generate cellphone = .
replace cellphone = 1 if qstver >= 20
replace cellphone = 0 if qstver < 20

generate prevent_services = dental + hivtest + flushot + checkup
*generate preventive services recieved variable for even years

generate householdsize = numadult + children
*generates householdsize

drop if income2 == 8
generate FPLDummy = .
replace FPLDummy = 10000 if income2 == 1
replace FPLDummy = 15000 if income2 == 2
replace FPLDummy = 20000 if income2 == 3
replace FPLDummy = 25000 if income2 == 4
replace FPLDummy = 35000 if income2 == 5
replace FPLDummy = 50000 if income2 == 6
replace FPLDummy = 75000 if income2 == 7
generate FPLIncome = .
replace FPLIncome = 10830 + (3740 * (householdsize - 1)) if year == 2010
replace FPLIncome = 10890 + (3820 * (householdsize - 1)) if year == 2011
replace FPLIncome = 11170 + (3960 * (householdsize - 1)) if year == 2012
replace FPLIncome = 11490 + (4020 * (householdsize - 1)) if year == 2013
replace FPLIncome = 11670 + (4060 * (householdsize - 1)) if year == 2014
replace FPLIncome = 11770 + (4160 * (householdsize - 1)) if year == 2015
generate FPL = FPLDummy/FPLIncome
*FPL Dummies

gen month = 0
replace month = 1 if imonth== 1
replace month = 2 if imonth== 2
replace month = 3 if imonth== 3
replace month = 4 if imonth== 4
replace month = 5 if imonth== 5
replace month = 6 if imonth== 6
replace month = 7 if imonth== 7
replace month = 8 if imonth== 8
replace month = 9 if imonth== 9
replace month = 10 if imonth== 10
replace month = 11 if imonth== 11
replace month = 12 if imonth== 12
*generating mont variable

gen quarter = 0
replace quarter = 1 if month>=1 & month<=3
replace quarter = 2 if month>=4 & month<=6
replace quarter = 3 if month>=7 & month<=9
replace quarter = 4 if month>=10 & month<=12
*create quarter variable

gen period = quarter + 4*(year-2010)
*unique period identifier 

generate insurance = 0
*insurance dummy

replace insurance = 1 if hlthpln1 == 1
*dummy 1 if have insurance

generate post = 1 if year >= 2014
replace post = 0 if year < 2014
generate diff_n_diff = (expansion_dummy * post)
*generates diff n diff variable

tab _state, gen(dummy_state)
*state fixed effects

tab year, gen(year_dummy)
*year fixed effects

merge m:1 _state year using "C:\Users\colin\OneDrive\Documents\UConn\Fourth Semester\Graduate Health Economics\Replication\Data\Unemployment_Rates.dta"
drop _merge
*merges data with unemployment rates by year

xtset _state
*prepares data for analysis

save "C:\Users\colin\OneDrive\Documents\UConn\Fourth Semester\Graduate Health Economics\Replication\Data\Master.dta", replace
*I have no idea why I didn't put this line in earlier

***Begin Analysis***

sum _age80 FPLDummy years_educ female married unemployment white black native_american asian hawaiian other multiracial hispanic if expansion_dummy == 1 & year <= 2013 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum _age80 FPLDummy years_educ female married unemployment white black native_american asian hawaiian other multiracial hispanic if expansion_dummy == 1 & year >= 2014 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum _age80 FPLDummy years_educ female married unemployment white black native_american asian hawaiian other multiracial hispanic if expansion_dummy == 0 & year <= 2013 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum _age80 FPLDummy years_educ female married unemployment white black native_american asian hawaiian other multiracial hispanic if expansion_dummy == 0 & year >= 2014 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
*summary statistics

count if expansion_dummy == 1 & FPL < 1 & _age80 < 65 
count if expansion_dummy == 0 & FPL < 1 & _age80 < 65 
*N

sum prevent_services checkup flushot hivtest if expansion_dummy == 1 & year <= 2013 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum prevent_services checkup flushot hivtest if expansion_dummy == 1 & year >= 2014 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum prevent_services checkup flushot hivtest if expansion_dummy == 0 & year <= 2013 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum prevent_services checkup flushot hivtest if expansion_dummy == 0 & year >= 2014 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
*weighted summaries

sum dental if expansion_dummy == 1 & year <= 2012 & year != 2011 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum dental if expansion_dummy == 1 & year == 2014 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum dental if expansion_dummy == 0 & year <= 2012 & year != 2011 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum dental if expansion_dummy == 0 & year == 2014 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
*dental summaries, accounting for null odd years

sum genhlth if expansion_dummy == 1 & year <= 2013 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum genhlth if expansion_dummy == 1 & year >= 2014 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum genhlth if expansion_dummy == 0 & year <= 2013 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum genhlth if expansion_dummy == 0 & year >= 2014 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
*general health summarized

sum insurance if expansion_dummy == 1 & year <= 2013 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum insurance if expansion_dummy == 1 & year >= 2014 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum insurance if expansion_dummy == 0 & year <= 2013 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
sum insurance if expansion_dummy == 0 & year >= 2014 & FPL < 1 & _age80 < 65 [aw= _llcpwt]
*insurance summarized

bysort period expansion_dummy: sum insurance [aw= _llcpwt]
bysort period expansion_dummy: sum checkup [aw= _llcpwt]
bysort period expansion_dummy: sum hivtest [aw= _llcpwt]
bysort period expansion_dummy: sum prevent_services [aw= _llcpwt]
bysort period expansion_dummy: sum flushot [aw= _llcpwt]
*data for graphs

sum insurance if year < 2014 & FPL < 1 & _age80 < 65
xtreg insurance diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1, vce(cluster _state)
sum insurance if year < 2014 & FPL < 1 & _age80 < 65 & female == 1
xtreg insurance diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 1, vce(cluster _state)
sum insurance if year < 2014 & FPL < 1 & _age80 < 65 & female == 0
xtreg insurance diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 0, vce(cluster _state)
*insurance DD part 1

sum prevent_services if year < 2014 & FPL < 1 & _age80 < 65
xtreg prevent_services diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1, vce(cluster _state)
sum prevent_services if year < 2014 & FPL < 1 & _age80 < 65 & female == 1
xtreg prevent_services diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 1, vce(cluster _state)
sum prevent_services if year < 2014 & FPL < 1 & _age80 < 65 & female == 0
xtreg prevent_services diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 0, vce(cluster _state)
*prevent_services DD part 1

sum checkup if year < 2014 & FPL < 1 & _age80 < 65
xtreg checkup diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1, vce(cluster _state)
sum checkup if year < 2014 & FPL < 1 & _age80 < 65 & female == 1
xtreg checkup diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 1, vce(cluster _state)
sum checkup if year < 2014 & FPL < 1 & _age80 < 65 & female == 0
xtreg checkup diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 0, vce(cluster _state)
*checkup DD part 1

sum flushot if year < 2014 & FPL < 1 & _age80 < 65
xtreg flushot diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1, vce(cluster _state)
sum flushot if year < 2014 & FPL < 1 & _age80 < 65 & female == 1
xtreg flushot diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 1, vce(cluster _state)
sum flushot if year < 2014 & FPL < 1 & _age80 < 65 & female == 0
xtreg flushot diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 0, vce(cluster _state)
*flushot DD part 1

sum hivtest if year < 2014 & FPL < 1 & _age80 < 65
xtreg hivtest diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1, vce(cluster _state)
sum hivtest if year < 2014 & FPL < 1 & _age80 < 65 & female == 1
xtreg hivtest diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 1, vce(cluster _state)
sum hivtest if year < 2014 & FPL < 1 & _age80 < 65 & female == 0
xtreg hivtest diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 0, vce(cluster _state)
*hivtest DD part 1

sum dental if year < 2014 & FPL < 1 & _age80 < 65
xtreg dental diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1, vce(cluster _state)
sum dental if year < 2014 & FPL < 1 & _age80 < 65 & female == 1
xtreg dental diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 1, vce(cluster _state)
sum dental if year < 2014 & FPL < 1 & _age80 < 65 & female == 0
xtreg dental diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 0, vce(cluster _state)
*dental DD part 1

sum genhlth if year < 2014 & FPL < 1 & _age80 < 65
xtreg genhlth diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1, vce(cluster _state)
sum genhlth if year < 2014 & FPL < 1 & _age80 < 65 & female == 1
xtreg genhlth diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 1, vce(cluster _state)
sum genhlth if year < 2014 & FPL < 1 & _age80 < 65 & female == 0
xtreg genhlth diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & female == 0, vce(cluster _state)
*genhlth DD part 1

sum insurance if year < 2014 & FPL < 1 & _age80 < 65 & childless == 1
xtreg insurance diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 1, vce(cluster _state)
sum insurance if year < 2014 & FPL < 1 & _age80 < 65 & childless == 0
xtreg insurance diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 0, vce(cluster _state)
*insurance DD part 2

sum prevent_services if year < 2014 & FPL < 1 & _age80 < 65 & childless == 1
xtreg prevent_services diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 1, vce(cluster _state)
sum prevent_services if year < 2014 & FPL < 1 & _age80 < 65 & childless == 0
xtreg prevent_services diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 0, vce(cluster _state)
*prevent_services DD part 2

sum checkup if year < 2014 & FPL < 1 & _age80 < 65 & childless == 1
xtreg checkup diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 1, vce(cluster _state)
sum checkup if year < 2014 & FPL < 1 & _age80 < 65 & childless == 0
xtreg checkup diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 0, vce(cluster _state)
*checkup DD part 2

sum flushot if year < 2014 & FPL < 1 & _age80 < 65 & childless == 1
xtreg flushot diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 1, vce(cluster _state)
sum flushot if year < 2014 & FPL < 1 & _age80 < 65 & childless == 0
xtreg flushot diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 0, vce(cluster _state)
*flushot DD part 2

sum hivtest if year < 2014 & FPL < 1 & _age80 < 65 & childless == 1
xtreg hivtest diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 1, vce(cluster _state)
sum hivtest if year < 2014 & FPL < 1 & _age80 < 65 & childless == 0
xtreg hivtest diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 0, vce(cluster _state)
*hivtest DD part 2

sum dental if year < 2014 & FPL < 1 & _age80 < 65 & childless == 1
xtreg dental diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 1, vce(cluster _state)
sum dental if year < 2014 & FPL < 1 & _age80 < 65 & childless == 0
xtreg dental diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 0, vce(cluster _state)
*dental DD part 2

sum genhlth if year < 2014 & FPL < 1 & _age80 < 65 & childless == 1
xtreg genhlth diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 1, vce(cluster _state)
sum genhlth if year < 2014 & FPL < 1 & _age80 < 65 & childless == 0
xtreg genhlth diff_n_diff FPLIncome years_educ male female white black native_american asian hawaiian other multiracial hispanic unemployment _age80 married householdsize cellphone unemployment_rate dummy_state* year_dummy* if _age80 < 65 & FPL < 1 & childless == 0, vce(cluster _state)
*genhlth DD part 2

*DONE!!!
